part of 'category_wise_feed_post_cubit.dart';

class CategoryWiseFeedPostState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SocialPostsList categoryWiseFeedPosts;
  const CategoryWiseFeedPostState({
    this.dataLoading = false,
    required this.categoryWiseFeedPosts,
    this.error,
  });

  @override
  List<Object?> get props => [categoryWiseFeedPosts, dataLoading, error];

  CategoryWiseFeedPostState copyWith({
    bool? dataLoading,
    SocialPostsList? categoryWiseFeedPosts,
    String? error,
  }) {
    return CategoryWiseFeedPostState(
      dataLoading: dataLoading ?? false,
      categoryWiseFeedPosts: categoryWiseFeedPosts ?? this.categoryWiseFeedPosts,
      error: error,
    );
  }
}
