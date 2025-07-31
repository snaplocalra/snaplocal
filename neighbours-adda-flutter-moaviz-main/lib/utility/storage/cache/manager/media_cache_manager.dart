import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../database/cache_database.dart';
import '../models/cached_media_model.dart';

class MediaCacheManager {
  static MediaCacheManager? _instance;
  static MediaCacheManager get instance => _instance ??= MediaCacheManager._();
  MediaCacheManager._();

  final Dio _dio = Dio();
  late Directory _cacheDirectory;
  bool _initialized = false;
  final Set<String> _downloadingUrls = {};

  // Cache size limits
  static const int maxCacheSizeBytes = 1024 * 1024 * 1024; // 1GB
  static const int maxCacheFiles = 1000;

  Future<void> initialize() async {
    if (_initialized) return;
    
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory(path.join(appDir.path, 'media_cache'));
    
    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }
    
    // Clean up expired cache on initialization
    await _cleanupExpiredCache();
    _initialized = true;
  }

  String _generateCacheKey(String url) {
    return md5.convert(url.codeUnits).toString();
  }

  Future<String> _getCacheFilePath(String url, String extension) async {
    final key = _generateCacheKey(url);
    return path.join(_cacheDirectory.path, '$key$extension');
  }

  Future<File?> getCachedFile(String url) async {
    await initialize();
    
    print('🔍 [CACHE] Checking cache for URL: ${url.substring(0, 50)}...');
    
    final cachedMedia = await CacheDatabase.getCachedMedia(url);
    if (cachedMedia != null && cachedMedia.exists && !cachedMedia.isExpired) {
      final file = File(cachedMedia.localPath);
      
      // Additional validation to ensure file is complete and usable
      try {
        final fileSize = await file.length();
        const minViableSize = 512 * 1024; // 512KB minimum for a video to be considered viable
        
        if (fileSize >= minViableSize) {
          print('✅ [CACHE HIT] Found viable cached file: ${cachedMedia.localPath} (${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB)');
          // Update last accessed time
          await CacheDatabase.updateLastAccessed(url);
          return file;
        } else {
          print('⚠️ [CACHE INCOMPLETE] File too small: ${fileSize} bytes, removing from cache');
          await CacheDatabase.deleteCachedMedia(url);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (e) {
        print('⚠️ [CACHE ERROR] Error checking file size: $e');
      }
    }
    
    // Remove invalid cache entry
    if (cachedMedia != null) {
      if (cachedMedia.isExpired) {
        print('⏰ [CACHE EXPIRED] Removing expired cache entry for URL');
      } else if (!cachedMedia.exists) {
        print('❌ [CACHE INVALID] File does not exist, removing cache entry');
      }
      await CacheDatabase.deleteCachedMedia(url);
      if (cachedMedia.exists) {
        try {
          await File(cachedMedia.localPath).delete();
        } catch (e) {
          print('⚠️ [CACHE] Error deleting cached file: $e');
        }
      }
    } else {
      print('❌ [CACHE MISS] No cache entry found for URL');
    }
    
    return null;
  }

  Future<File?> downloadAndCache(String url, {String? thumbnailUrl, Function(String)? onDone, Function(String, dynamic)? onError}) async {
    await initialize();
    
    if (_downloadingUrls.contains(url)) {
      print('🟠 [DOWNLOAD] Already downloading: ${url.substring(0, 50)}...');
      return null;
    }
    
    print('⬇️ [DOWNLOAD] Starting download for URL: ${url.substring(0, 50)}...');
    
    try {
      _downloadingUrls.add(url);
      // Check if already cached and viable
      final existingFile = await getCachedFile(url);
      if (existingFile != null) {
        print('✅ [DOWNLOAD] File already cached and viable, returning existing file');
        onDone?.call(url);
        return existingFile;
      }

      // Ensure we don't exceed cache limits
      await _enforceCacheLimits();

      // Determine file extension
      final uri = Uri.parse(url);
      final fileExtension = path.extension(uri.path).isEmpty ? '.mp4' : path.extension(uri.path);
      
      final filePath = await _getCacheFilePath(url, fileExtension);
      final file = File(filePath);

      print('⬇️ [DOWNLOAD] Downloading to: $filePath');
      
      // Download the file with progress tracking
      final response = await _dio.download(
        url, 
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            print('📥 [DOWNLOAD] Progress: $progress% ($received/$total bytes)');
          }
        },
      );
      
      if (response.statusCode == 200) {
        final fileSize = await file.length();
        print('✅ [DOWNLOAD] Successfully downloaded ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');
        
        // Validate the downloaded file before caching
        const minViableSize = 512 * 1024; // 512KB minimum
        if (fileSize < minViableSize) {
          print('❌ [DOWNLOAD] Downloaded file too small, not caching');
          await file.delete();
          return null;
        }
        
        String? thumbnailLocalPath;
        
        // Download thumbnail if provided
        if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
          try {
            print('🖼️ [THUMBNAIL] Downloading thumbnail...');
            final thumbExtension = path.extension(Uri.parse(thumbnailUrl).path).isEmpty 
                ? '.jpg' 
                : path.extension(Uri.parse(thumbnailUrl).path);
            thumbnailLocalPath = await _getCacheFilePath(thumbnailUrl, thumbExtension);
            await _dio.download(thumbnailUrl, thumbnailLocalPath);
            print('✅ [THUMBNAIL] Successfully downloaded thumbnail');
          } catch (e) {
            print('⚠️ [THUMBNAIL] Error downloading thumbnail: $e');
          }
        }

        // Save to database
        final cachedMedia = CachedMediaModel(
          id: _generateCacheKey(url),
          url: url,
          localPath: filePath,
          thumbnailPath: thumbnailLocalPath,
          cachedAt: DateTime.now(),
          fileSize: fileSize,
          mediaType: _getMediaType(fileExtension),
          lastAccessed: DateTime.now(),
        );

        await CacheDatabase.insertCachedMedia(cachedMedia);
        print('💾 [DATABASE] Saved cache entry to database');
        onDone?.call(url);
        return file;
      } else {
        print('❌ [DOWNLOAD] Failed with status code: ${response.statusCode}');
        onError?.call(url, 'Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [DOWNLOAD] Error downloading and caching media: $e');
      onError?.call(url, e);
    } finally {
      _downloadingUrls.remove(url);
    }
    
    return null;
  }

  String _getMediaType(String fileExtension) {
    if (['.mp4', '.mov', '.avi', '.mkv'].contains(fileExtension.toLowerCase())) {
      return 'video';
    } else if (['.jpg', '.jpeg', '.png', '.gif'].contains(fileExtension.toLowerCase())) {
      return 'image';
    }
    return 'unknown';
  }

  Future<void> _enforceCacheLimits() async {
    final cacheSize = await CacheDatabase.getCacheSize();
    
    if (cacheSize > maxCacheSizeBytes) {
      await _cleanupOldestCache();
    }
  }

  Future<void> _cleanupOldestCache() async {
    final allCached = await CacheDatabase.getAllCachedMedia();
    
    // Sort by last accessed (oldest first)
    allCached.sort((a, b) {
      final aAccessed = a.lastAccessed ?? a.cachedAt;
      final bAccessed = b.lastAccessed ?? b.cachedAt;
      return aAccessed.compareTo(bAccessed);
    });

    // Remove 25% of oldest files
    final toRemove = (allCached.length * 0.25).ceil();
    
    for (int i = 0; i < toRemove && i < allCached.length; i++) {
      final media = allCached[i];
      await _deleteCachedMedia(media);
    }
  }

  Future<void> _cleanupExpiredCache() async {
    await CacheDatabase.clearExpiredCache();
    
    // Also clean up orphaned files
    final cachedMedia = await CacheDatabase.getAllCachedMedia();
    final validPaths = cachedMedia.map((m) => m.localPath).toSet();
    
    if (await _cacheDirectory.exists()) {
      await for (final entity in _cacheDirectory.list()) {
        if (entity is File && !validPaths.contains(entity.path)) {
          try {
            await entity.delete();
          } catch (e) {
            print('Error deleting orphaned file: $e');
          }
        }
      }
    }
  }

  Future<void> _deleteCachedMedia(CachedMediaModel media) async {
    try {
      // Delete file
      final file = File(media.localPath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Delete thumbnail if exists
      if (media.thumbnailPath != null) {
        final thumbFile = File(media.thumbnailPath!);
        if (await thumbFile.exists()) {
          await thumbFile.delete();
        }
      }
      
      // Remove from database
      await CacheDatabase.deleteCachedMedia(media.url);
    } catch (e) {
      print('Error deleting cached media: $e');
    }
  }

  Future<void> clearAllCache() async {
    await initialize();
    
    try {
      // Delete all files in cache directory
      if (await _cacheDirectory.exists()) {
        await _cacheDirectory.delete(recursive: true);
        await _cacheDirectory.create(recursive: true);
      }
      
      // Clear database
      final allCached = await CacheDatabase.getAllCachedMedia();
      for (final media in allCached) {
        await CacheDatabase.deleteCachedMedia(media.url);
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<Map<String, dynamic>> getCacheStats() async {
    await initialize();
    
    final allCached = await CacheDatabase.getAllCachedMedia();
    final totalSize = await CacheDatabase.getCacheSize();
    
    return {
      'totalFiles': allCached.length,
      'totalSize': totalSize,
      'maxSize': maxCacheSizeBytes,
      'usagePercentage': (totalSize / maxCacheSizeBytes * 100).clamp(0, 100),
    };
  }

  // Preload media for upcoming posts
  Future<void> preloadMedia(Map<String, String?> urlToThumbnailMap, {Function(String)? onStart, Function(String)? onDone, Function(String, dynamic)? onError}) async {
    print('🚀 [PRELOAD] Starting preload for ${urlToThumbnailMap.length} URLs');
    for (final entry in urlToThumbnailMap.entries) {
      final url = entry.key;
      final thumbnailUrl = entry.value;
      if (url.isNotEmpty) {
        // Check if already cached or currently downloading
        final cachedFile = await getCachedFile(url);
        if (cachedFile == null && !_downloadingUrls.contains(url)) {
          print('🚀 [PRELOAD] Preloading: ${url.substring(0, 50)}...');
          onStart?.call(url);
          // Run in background without waiting
          downloadAndCache(url, thumbnailUrl: thumbnailUrl, onDone: onDone, onError: onError).then((file) {
            if (file != null) {
              print('✅ [PRELOAD] Successfully preloaded: ${url.substring(0, 50)}...');
            } else {
              print('ⓘ [PRELOAD] Finished preload attempt for: ${url.substring(0, 50)}...');
            }
          }).catchError((e) {
            print('❌ [PRELOAD] Error preloading media: $e');
            onError?.call(url, e);
          });
        } else {
          print('ⓘ [PRELOAD] Skipping already cached or downloading URL: ${url.substring(0, 50)}...');
        }
      }
    }
  }
}
