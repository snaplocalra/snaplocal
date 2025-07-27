part of 'post_reaction_details_cubit.dart';

class PostReactionDetailsState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final PostReactionDetails? postReactionDetails;
  const PostReactionDetailsState({
    this.isLoading = false,
    this.errorMessage,
    this.postReactionDetails,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, postReactionDetails];

  PostReactionDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    PostReactionDetails? postReactionDetails,
  }) {
    return PostReactionDetailsState(
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
      postReactionDetails: postReactionDetails,
    );
  }
}
