part of 'comment_controller_cubit.dart';

class CommentControllerState extends Equatable {
  final bool commentLoading;

  final CommentListModel commentListModel;
  const CommentControllerState({
    this.commentLoading = false,
    required this.commentListModel,
  });

  //get the total count of the comments and the replies
  int get totalCommentsCount {
    int count = commentListModel.data.length;
    for (var comment in commentListModel.data) {
      count += comment.reply?.length ?? 0;
    }
    return count;
  }

  @override
  List<Object> get props => [commentLoading, commentListModel];

  CommentControllerState copyWith({
    bool? commentLoading,
    CommentListModel? commentListModel,
  }) {
    return CommentControllerState(
      commentLoading: commentLoading ?? this.commentLoading,
      commentListModel: commentListModel ?? this.commentListModel,
    );
  }
}
