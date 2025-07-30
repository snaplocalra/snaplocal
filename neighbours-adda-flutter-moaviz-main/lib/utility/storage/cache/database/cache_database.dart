import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cached_media_model.dart';

class CacheDatabase {
  static const String _cacheKey = 'cached_media_list';

  static Future<List<CachedMediaModel>> getAllCachedMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CachedMediaModel.fromJson(json)).toList();
  }

  static Future<CachedMediaModel?> getCachedMedia(String url) async {
    final allMedia = await getAllCachedMedia();
    try {
      final media = allMedia.firstWhere((media) => media.url == url);
      print('📊 [DB] Found cache entry for URL in database');
      return media;
    } catch (e) {
      print('📊 [DB] No cache entry found in database for URL');
      return null;
    }
  }

  static Future<void> insertCachedMedia(CachedMediaModel media) async {
    print('📊 [DB] Inserting cache entry for URL: ${media.url.substring(0, 50)}...');
    final allMedia = await getAllCachedMedia();
    
    // Remove existing entry with same URL
    allMedia.removeWhere((m) => m.url == media.url);
    
    // Add new entry
    allMedia.add(media);
    
    await _saveAllMedia(allMedia);
    print('📊 [DB] Successfully inserted cache entry');
  }

  static Future<void> deleteCachedMedia(String url) async {
    final allMedia = await getAllCachedMedia();
    allMedia.removeWhere((media) => media.url == url);
    await _saveAllMedia(allMedia);
  }

  static Future<void> updateLastAccessed(String url) async {
    print('📊 [DB] Updating last accessed time for URL');
    final allMedia = await getAllCachedMedia();
    final index = allMedia.indexWhere((media) => media.url == url);
    
    if (index != -1) {
      final updatedMedia = allMedia[index].copyWith(
        lastAccessed: DateTime.now(),
      );
      
      allMedia[index] = updatedMedia;
      await _saveAllMedia(allMedia);
      print('📊 [DB] Successfully updated last accessed time');
    } else {
      print('📊 [DB] Could not find entry to update last accessed time');
    }
  }

  static Future<int> getCacheSize() async {
    final allMedia = await getAllCachedMedia();
    final size = allMedia.fold<int>(0, (sum, media) => sum + media.fileSize);
    print('📊 [DB] Total cache size: ${(size / (1024 * 1024)).toStringAsFixed(2)} MB');
    return size;
  }

  static Future<void> clearExpiredCache() async {
    final allMedia = await getAllCachedMedia();
    final validMedia = allMedia.where((media) => !media.isExpired).toList();
    await _saveAllMedia(validMedia);
  }

  static Future<void> _saveAllMedia(List<CachedMediaModel> mediaList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(mediaList.map((m) => m.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }
}
