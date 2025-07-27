// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'neighbours_profile_cubit.dart';

class NeighboursProfileState extends Equatable {
  final bool isDataLoaded;
  final bool dataLoading;
  final String? error;
  final NeighboursProfileModel? neighboursProfileModel;
  const NeighboursProfileState({
    this.isDataLoaded = false,
    this.dataLoading = false,
    this.neighboursProfileModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        neighboursProfileModel,
        isDataLoaded,
        dataLoading,
        error,
      ];

  NeighboursProfileState copyWith({
    bool? isDataLoaded,
    bool? dataLoading,
    NeighboursProfileModel? neighboursProfileModel,
    String? error,
  }) {
    return NeighboursProfileState(
      isDataLoaded: isDataLoaded ?? false,
      dataLoading: dataLoading ?? false,
      neighboursProfileModel:
          neighboursProfileModel ?? this.neighboursProfileModel,
      error: error,
    );
  }
}
