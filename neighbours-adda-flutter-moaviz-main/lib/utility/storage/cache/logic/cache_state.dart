part of 'cache_cubit.dart';

class CacheState extends Equatable {
  final bool isInitialized;
  final bool isInitializing;
  final bool isClearingCache;
  final Map<String, dynamic> cacheStats;
  final String? error;
  final Set<String> preloadingUrls;

  const CacheState({
    this.isInitialized = false,
    this.isInitializing = false,
    this.isClearingCache = false,
    this.cacheStats = const {},
    this.error,
    this.preloadingUrls = const {},
  });

  @override
  List<Object?> get props => [
        isInitialized,
        isInitializing,
        isClearingCache,
        cacheStats,
        error,
        preloadingUrls,
      ];

  CacheState copyWith({
    bool? isInitialized,
    bool? isInitializing,
    bool? isClearingCache,
    Map<String, dynamic>? cacheStats,
    String? error,
    Set<String>? preloadingUrls,
  }) {
    return CacheState(
      isInitialized: isInitialized ?? this.isInitialized,
      isInitializing: isInitializing ?? this.isInitializing,
      isClearingCache: isClearingCache ?? this.isClearingCache,
      cacheStats: cacheStats ?? this.cacheStats,
      error: error,
      preloadingUrls: preloadingUrls ?? this.preloadingUrls,
    );
  }
}
