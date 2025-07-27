part of 'send_comment_cubit.dart';

sealed class SendCommentState extends Equatable {
  const SendCommentState();

  @override
  List<Object> get props => [];
}

final class PostCommentInitial extends SendCommentState {}

final class OnComment extends SendCommentState {
  final String comment;

  const OnComment(this.comment);

  @override
  List<Object> get props => [comment];
}
