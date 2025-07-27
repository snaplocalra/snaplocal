part of 'own_posts_cubit.dart';

class OwnPostsState extends Equatable {
  final bool dataLoading;
  final SocialPostsList ownPosts;
  final String? error;

  const OwnPostsState({
    this.dataLoading = false,
    required this.ownPosts,
    this.error,
  });

  @override
  List<Object?> get props => [ownPosts, dataLoading, error];

  OwnPostsState copyWith({
    bool? dataLoading,
    SocialPostsList? ownPosts,
    String? error,
  }) {
    return OwnPostsState(
      dataLoading: dataLoading ?? false,
      ownPosts: ownPosts ?? this.ownPosts,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownPosts': ownPosts.toMap(),
    };
  }

  factory OwnPostsState.fromMap(Map<String, dynamic> map) {
    return OwnPostsState(
      ownPosts:
          SocialPostsList.fromMap(map['ownPosts'] as Map<String, dynamic>),
    );
  }
}
