import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/media_cache_manager.dart';
import '../manager/background_cache_service.dart';

part 'cache_state.dart';

class CacheCubit extends Cubit<CacheState> {
  CacheCubit() : super(const CacheState());

  Future<void> initializeCache() async {
    emit(state.copyWith(isInitializing: true));
    
    try {
      await MediaCacheManager.instance.initialize();
      await BackgroundCacheService.initialize();
      final stats = await MediaCacheManager.instance.getCacheStats();
      
      emit(state.copyWith(
        isInitialized: true,
        isInitializing: false,
        cacheStats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isInitializing: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> updateCacheStats() async {
    try {
      final stats = await MediaCacheManager.instance.getCacheStats();
      emit(state.copyWith(cacheStats: stats));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> clearCache() async {
    emit(state.copyWith(isClearingCache: true));
    
    try {
      await MediaCacheManager.instance.clearAllCache();
      final stats = await MediaCacheManager.instance.getCacheStats();
      
      emit(state.copyWith(
        isClearingCache: false,
        cacheStats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isClearingCache: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> preloadUrls(Map<String, String?> urlToThumbnailMap) async {
    print('📱 [CACHE_CUBIT] Preloading ${urlToThumbnailMap.length} URLs');
    
    try {
      await MediaCacheManager.instance.preloadMedia(
        urlToThumbnailMap,
        onStart: (url) {
          final currentPreloading = Set<String>.from(state.preloadingUrls);
          currentPreloading.add(url);
          emit(state.copyWith(preloadingUrls: currentPreloading));
        },
        onDone: (url) {
          final currentPreloading = Set<String>.from(state.preloadingUrls);
          currentPreloading.remove(url);
          emit(state.copyWith(preloadingUrls: currentPreloading));
          updateCacheStats(); // Update stats after a successful download
        },
        onError: (url, error) {
          final currentPreloading = Set<String>.from(state.preloadingUrls);
          currentPreloading.remove(url);
          emit(state.copyWith(preloadingUrls: currentPreloading));
        },
      );
      print('📱 [CACHE_CUBIT] Preload request sent successfully');
    } catch (e) {
      print('📱 [CACHE_CUBIT] Error in preload: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> triggerBackgroundCache() async {
    try {
      await BackgroundCacheService.triggerImmediateCache();
      print('📱 [CACHE_CUBIT] Background cache triggered');
    } catch (e) {
      print('📱 [CACHE_CUBIT] Error triggering background cache: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }
}
