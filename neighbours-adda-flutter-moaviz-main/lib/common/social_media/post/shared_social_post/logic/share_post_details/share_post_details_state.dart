part of 'share_post_details_cubit.dart';

class PostDetailsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SocialPostModel? socialPostDetails;
  const PostDetailsState({
    this.dataLoading = false,
    this.error,
    this.socialPostDetails,
  });

  @override
  List<Object?> get props => [dataLoading, error, socialPostDetails];

  PostDetailsState copyWith({
    bool? dataLoading,
    String? error,
    SocialPostModel? socialPostDetails,
  }) {
    return PostDetailsState(
      dataLoading: dataLoading ?? false,
      error: error,
      socialPostDetails: socialPostDetails ?? this.socialPostDetails,
    );
  }
}
