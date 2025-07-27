part of 'home_search_category_type_cubit.dart';

class ExploreCategoryTypeState extends Equatable {
  final bool dataLoading;
  final String? error;
  final ExploreTypeListModel homeSearchTypeListModel;
  const ExploreCategoryTypeState({
    this.dataLoading = false,
    this.error,
    required this.homeSearchTypeListModel,
  });

  @override
  List<Object?> get props => [homeSearchTypeListModel, dataLoading, error];

  ExploreCategoryTypeState copyWith({
    bool? dataLoading,
    String? error,
    ExploreTypeListModel? homeSearchTypeListModel,
  }) {
    return ExploreCategoryTypeState(
      dataLoading: dataLoading ?? false,
      error: error,
      homeSearchTypeListModel:
          homeSearchTypeListModel ?? this.homeSearchTypeListModel,
    );
  }
}
