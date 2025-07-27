// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'page_details_cubit.dart';

class PageDetailsState extends Equatable {
  final PageDetailsModel? pageDetailsModel;
  final String? error;
  final bool dataLoading;

  final bool favoriteLoading;

  const PageDetailsState({
    this.pageDetailsModel,
    this.error,
    this.dataLoading = false,
    this.favoriteLoading = false,
  });

  @override
  List<Object?> get props => [
        pageDetailsModel,
        error,
        dataLoading,
        favoriteLoading,
      ];

  PageDetailsState copyWith({
    PageDetailsModel? pageDetailsModel,
    String? error,
    bool? dataLoading,
    bool? favoriteLoading,
  }) {
    return PageDetailsState(
      pageDetailsModel: pageDetailsModel ?? this.pageDetailsModel,
      error: error,
      dataLoading: dataLoading ?? false,
      favoriteLoading: favoriteLoading ?? false,
    );
  }
}
