part of 'video_feed_posts_cubit.dart';

class VideoSocialPostsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SocialPostsList feedPosts;
  const VideoSocialPostsState({
    this.dataLoading = false,
    required this.feedPosts,
    this.error,
  });

  @override
  List<Object?> get props => [feedPosts, dataLoading, error];

  VideoSocialPostsState copyWith({
    bool? dataLoading,
    SocialPostsList? feedPosts,
    String? error,
  }) {
    return VideoSocialPostsState(
      dataLoading: dataLoading ?? false,
      feedPosts: feedPosts ?? this.feedPosts,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'feedPosts': feedPosts.toMap()};
  }

  factory VideoSocialPostsState.fromMap(Map<String, dynamic> map) {
    return VideoSocialPostsState(
      feedPosts:
          SocialPostsList.fromMap(map['feedPosts'] as Map<String, dynamic>),
    );
  }
}
