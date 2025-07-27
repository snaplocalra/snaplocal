part of 'page_list_cubit.dart';

class PageListState extends Equatable {
  final bool isPagesYouFollowDataLoading;
  final bool isManagedByYouDataLoading;
  final String? error;
  final PageTypeListModel pageTypeListModel;
  const PageListState({
    this.isPagesYouFollowDataLoading = false,
    this.isManagedByYouDataLoading = false,
    required this.pageTypeListModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isPagesYouFollowDataLoading,
        isManagedByYouDataLoading,
        pageTypeListModel,
        error
      ];

  PageListState copyWith({
    bool? isPagesYouFollowDataLoading,
    bool? isManagedByYouDataLoading,
    PageTypeListModel? pageTypeListModel,
    String? error,
  }) {
    return PageListState(
      isPagesYouFollowDataLoading: isPagesYouFollowDataLoading ?? false,
      isManagedByYouDataLoading: isManagedByYouDataLoading ?? false,
      pageTypeListModel: pageTypeListModel ?? this.pageTypeListModel,
      error: error,
    );
  }
}
