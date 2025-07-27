part of 'post_view_filter_cubit.dart';

class PostViewFilterState extends Equatable {
  final bool dataLoading;
  final bool allowFetchData;
  final List<PostViewFilterCategory> postFilters;

  //if the selected view filter is not found, then return null
  PostViewFilterCategory? get selectedViewFilter {
    return postFilters.firstWhereOrNull((element) => element.isSelected);
  }

  const PostViewFilterState({
    this.dataLoading = false,
    this.allowFetchData = false,
    required this.postFilters,
  });

  String get filterJson => jsonEncode(filterMap);

  Map<String, dynamic> get filterMap =>
      ({'type': selectedViewFilter?.postType.param});

  @override
  List<Object> get props => [
        dataLoading,
        allowFetchData,
        postFilters,
      ];

  //copy with
  PostViewFilterState copyWith({
    bool? dataLoading,
    List<PostViewFilterCategory>? postFilters,
    bool? allowFetchData,
  }) {
    return PostViewFilterState(
      dataLoading: dataLoading ?? false,
      allowFetchData: allowFetchData ?? false,
      postFilters: postFilters ?? this.postFilters,
    );
  }
}

class PostViewFilterCategory {
  final PostType postType;
  final bool isSelected;

  PostViewFilterCategory({
    required this.postType,
    this.isSelected = false,
  });

  PostViewFilterCategory copyWith({
    PostType? postType,
    bool? isSelected,
  }) {
    return PostViewFilterCategory(
      postType: postType ?? this.postType,
      isSelected: isSelected ?? false,
    );
  }
}
