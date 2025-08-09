import 'dart:io';
import 'package:workmanager/workmanager.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';
import 'package:snap_local/common/social_media/post/video_feed/repository/video_data_repository.dart';
import 'package:snap_local/utility/storage/cache/manager/media_cache_manager.dart';
import 'package:snap_local/utility/storage/cache/database/cache_database.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';

class BackgroundCacheService {
  static const String _taskName = 'background_cache_task';
  static const String _periodicTaskName = 'periodic_cache_task';
  
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    
    await scheduleBackgroundCaching();
  }

  static Future<void> scheduleBackgroundCaching() async {
    // Cancel existing tasks
    await Workmanager().cancelAll();
    
    // Schedule periodic background caching (every 6 hours)
    await Workmanager().registerPeriodicTask(
      _periodicTaskName,
      _periodicTaskName,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 15),
    );
  }

  static Future<void> executeBackgroundCache() async {
    try {
      print('🔄 [BACKGROUND_CACHE] Starting background cache process');
      
      await MediaCacheManager.instance.initialize();
      
      // Check if user is authenticated
      final userId = await AuthenticationTokenSharedPref().getUserId();
      if (userId.isEmpty) {
        print('❌ [BACKGROUND_CACHE] User not authenticated, skipping cache');
        return;
      }

      final urlToThumbnailMap = <String, String?>{};
      
      // Cache home feed posts
      try {
        final homeRepository = HomeDataRepository();
        final homePosts = await homeRepository.fetchHomeSocialPosts(page: 1);
        
        for (final post in homePosts.socialPostList.take(5)) {
          if (post.media.isNotEmpty) {
            for (final media in post.media) {
              if (media.mediaType == 'video' && media.mediaPath.isNotEmpty) {
                urlToThumbnailMap[media.mediaPath] = media.thumbnail;
              }
            }
          }
        }
        print('📱 [BACKGROUND_CACHE] Added ${homePosts.socialPostList.length} home posts for caching');
      } catch (e) {
        print('❌ [BACKGROUND_CACHE] Error fetching home posts: $e');
      }

      // Cache video feed posts
      try {
        final videoRepository = VideoDataRepository();
        final videoPosts = await videoRepository.fetchVideoPosts(page: 1);
        
        for (final post in videoPosts.socialPostList.take(5)) {
          if (post.media.isNotEmpty) {
            for (final media in post.media) {
              if (media.mediaType == 'video' && media.mediaPath.isNotEmpty) {
                urlToThumbnailMap[media.mediaPath] = media.thumbnail;
              }
            }
          }
        }
        print('📱 [BACKGROUND_CACHE] Added ${videoPosts.socialPostList.length} video posts for caching');
      } catch (e) {
        print('❌ [BACKGROUND_CACHE] Error fetching video posts: $e');
      }

      // Start background caching
      if (urlToThumbnailMap.isNotEmpty) {
        print('📱 [BACKGROUND_CACHE] Starting cache for ${urlToThumbnailMap.length} media items');
        
        int cached = 0;
        int failed = 0;
        
        for (final entry in urlToThumbnailMap.entries) {
          try {
            final cachedFile = await MediaCacheManager.instance.getCachedFile(entry.key);
            if (cachedFile == null) {
              final file = await MediaCacheManager.instance.downloadAndCache(
                entry.key,
                thumbnailUrl: entry.value,
              );
              if (file != null) {
                cached++;
                print('✅ [BACKGROUND_CACHE] Cached: ${entry.key.substring(0, 50)}...');
              } else {
                failed++;
              }
            } else {
              print('ℹ️ [BACKGROUND_CACHE] Already cached: ${entry.key.substring(0, 50)}...');
            }
          } catch (e) {
            failed++;
            print('❌ [BACKGROUND_CACHE] Failed to cache ${entry.key.substring(0, 50)}...: $e');
          }
        }
        
        print('🎉 [BACKGROUND_CACHE] Completed: $cached cached, $failed failed');
      } else {
        print('ℹ️ [BACKGROUND_CACHE] No media to cache');
      }

      // Clean up old cache entries to manage storage
      await _cleanupOldCache();
      
    } catch (e) {
      print('❌ [BACKGROUND_CACHE] Background cache error: $e');
    }
  }

  static Future<void> _cleanupOldCache() async {
    try {
      final stats = await MediaCacheManager.instance.getCacheStats();
      final usagePercentage = stats['usagePercentage'] as double;
      
      if (usagePercentage > 80) {
        print('🧹 [BACKGROUND_CACHE] Cache usage at $usagePercentage%, cleaning up...');
        
        final allCached = await CacheDatabase.getAllCachedMedia();
        
        // Sort by last accessed (oldest first) and remove 20% of files
        allCached.sort((a, b) {
          final aAccessed = a.lastAccessed ?? a.cachedAt;
          final bAccessed = b.lastAccessed ?? b.cachedAt;
          return aAccessed.compareTo(bAccessed);
        });

        final toRemove = (allCached.length * 0.2).ceil();
        
        for (int i = 0; i < toRemove && i < allCached.length; i++) {
          try {
            final media = allCached[i];
            await CacheDatabase.deleteCachedMedia(media.url);
            final file = File(media.localPath);
            if (await file.exists()) {
              await file.delete();
            }
            if (media.thumbnailPath != null) {
              final thumbFile = File(media.thumbnailPath!);
              if (await thumbFile.exists()) {
                await thumbFile.delete();
              }
            }
          } catch (e) {
            print('⚠️ [BACKGROUND_CACHE] Error deleting cached file: $e');
          }
        }
        
        print('🧹 [BACKGROUND_CACHE] Cleaned up $toRemove old cache entries');
      }
    } catch (e) {
      print('❌ [BACKGROUND_CACHE] Error during cleanup: $e');
    }
  }

  static Future<void> triggerImmediateCache() async {
    await Workmanager().registerOneOffTask(
      _taskName,
      _taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('📱 [WORKMANAGER] Executing background task: $task');
      
      switch (task) {
        case BackgroundCacheService._taskName:
        case BackgroundCacheService._periodicTaskName:
          await BackgroundCacheService.executeBackgroundCache();
          break;
        default:
          print('❓ [WORKMANAGER] Unknown task: $task');
          return false;
      }
      
      print('✅ [WORKMANAGER] Task completed successfully: $task');
      return true;
    } catch (e) {
      print('❌ [WORKMANAGER] Task failed: $task, error: $e');
      return false;
    }
  });
}
