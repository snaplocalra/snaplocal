import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/media_cache_manager.dart';

part 'cache_state.dart';

class CacheCubit extends Cubit<CacheState> {
  CacheCubit() : super(const CacheState());

  Future<void> initializeCache() async {
    emit(state.copyWith(isInitializing: true));
    
    try {
      await MediaCacheManager.instance.initialize();
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

  Future<void> preloadUrls(List<String> urls) async {
    print('📱 [CACHE_CUBIT] Preloading ${urls.length} URLs');
    try {
      await MediaCacheManager.instance.preloadMedia(urls);
      print('📱 [CACHE_CUBIT] Preload request sent successfully');
    } catch (e) {
      print('📱 [CACHE_CUBIT] Error in preload: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }
}
