part of 'home_feed_posts_cubit.dart';

class HomeSocialPostsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SocialPostsList feedPosts;
  const HomeSocialPostsState({
    this.dataLoading = false,
    required this.feedPosts,
    this.error,
  });

  @override
  List<Object?> get props => [feedPosts, dataLoading, error];

  HomeSocialPostsState copyWith({
    bool? dataLoading,
    SocialPostsList? feedPosts,
    String? error,
  }) {
    return HomeSocialPostsState(
      dataLoading: dataLoading ?? false,
      feedPosts: feedPosts ?? this.feedPosts,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'feedPosts': feedPosts.toMap()};
  }

  factory HomeSocialPostsState.fromMap(Map<String, dynamic> map) {
    return HomeSocialPostsState(
      feedPosts:
          SocialPostsList.fromMap(map['feedPosts'] as Map<String, dynamic>),
    );
  }
}
