part of 'favorite_location_cubit.dart';

class FavoriteLocationState extends Equatable {
  final bool dataLoading;
  final bool manageLocationLoading;
  final bool manageLocationSuccess;
  final bool deleteLocationLoading;
  final bool deleteLocationSuccess;
  final String? error;
  final FavoriteLocationModel? favoriteLocationModel;
  const FavoriteLocationState({
    this.dataLoading = false,
    this.manageLocationLoading = false,
    this.manageLocationSuccess = false,
    this.deleteLocationLoading = false,
    this.deleteLocationSuccess = false,
    this.error,
    this.favoriteLocationModel,
  });

  @override
  List<Object?> get props => [
        dataLoading,
        manageLocationLoading,
        manageLocationSuccess,
        deleteLocationLoading,
        deleteLocationSuccess,
        error,
        favoriteLocationModel,
      ];

  FavoriteLocationState copyWith({
    bool? dataLoading,
    bool? manageLocationLoading,
    bool? manageLocationSuccess,
    bool? deleteLocationLoading,
    bool? deleteLocationSuccess,
    String? error,
    FavoriteLocationModel? favoriteLocationModel,
  }) {
    return FavoriteLocationState(
      dataLoading: dataLoading ?? false,
      manageLocationLoading: manageLocationLoading ?? false,
      manageLocationSuccess: manageLocationSuccess ?? false,
      deleteLocationLoading: deleteLocationLoading ?? false,
      deleteLocationSuccess: deleteLocationSuccess ?? false,
      error: error,
      favoriteLocationModel:
          favoriteLocationModel ?? this.favoriteLocationModel,
    );
  }
}
