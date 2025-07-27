part of 'neighbours_posts_cubit.dart';

class NeighboursPostsState extends Equatable {
  final bool dataLoading;
  final SocialPostsList posts;
  final String? error;

  const NeighboursPostsState({
    this.dataLoading = false,
    required this.posts,
    this.error,
  });

  @override
  List<Object?> get props => [posts, dataLoading, error];

  NeighboursPostsState copyWith({
    bool? dataLoading,
    SocialPostsList? posts,
    String? error,
  }) {
    return NeighboursPostsState(
      dataLoading: dataLoading ?? false,
      posts: posts ?? this.posts,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'posts': posts.toMap(),
    };
  }

  factory NeighboursPostsState.fromMap(Map<String, dynamic> map) {
    return NeighboursPostsState(
      posts: SocialPostsList.fromMap(map['posts'] as Map<String, dynamic>),
    );
  }
}
