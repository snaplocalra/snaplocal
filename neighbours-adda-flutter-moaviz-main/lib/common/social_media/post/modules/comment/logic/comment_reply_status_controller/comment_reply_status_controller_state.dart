part of 'comment_reply_status_controller_cubit.dart';

class CommentReplyStatusControllerState extends Equatable {
  final String userName;
  final bool isReply;
  const CommentReplyStatusControllerState({
    required this.userName,
    required this.isReply,
  });

  @override
  List<Object> get props => [userName, isReply];

  CommentReplyStatusControllerState copyWith({
    String? userName,
    bool? isReply,
  }) {
    return CommentReplyStatusControllerState(
      userName: userName ?? this.userName,
      isReply: isReply ?? false,
    );
  }
}
