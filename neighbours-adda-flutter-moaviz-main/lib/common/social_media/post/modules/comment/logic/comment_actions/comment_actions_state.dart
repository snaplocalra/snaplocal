part of 'comment_actions_cubit.dart';

class CommentActionsState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  final bool increaseCommentCount;
  final bool decreaseCommentCount;
  final bool deleteSuccess;
  const CommentActionsState({
    this.requestLoading = false,
    this.requestSuccess = false,
    this.deleteSuccess = false,
    this.increaseCommentCount = false,
    this.decreaseCommentCount = false,
  });

  @override
  List<Object?> get props => [
        requestLoading,
        requestSuccess,
        deleteSuccess,
        increaseCommentCount,
        decreaseCommentCount,
      ];

  CommentActionsState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
    bool? deleteSuccess,
    bool? increaseCommentCount,
    bool? decreaseCommentCount,
  }) {
    return CommentActionsState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      deleteSuccess: deleteSuccess ?? false,
      increaseCommentCount: increaseCommentCount ?? false,
      decreaseCommentCount: decreaseCommentCount ?? false,
    );
  }
}
