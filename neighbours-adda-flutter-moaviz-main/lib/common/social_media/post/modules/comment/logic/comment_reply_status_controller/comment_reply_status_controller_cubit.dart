import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comment_reply_status_controller_state.dart';

class CommentReplyStatusControllerCubit
    extends Cubit<CommentReplyStatusControllerState> {
  final String ownerName;
  CommentReplyStatusControllerCubit({required this.ownerName})
      : super(CommentReplyStatusControllerState(
            userName: ownerName, isReply: false));

  void toggleReply({String? userName, required bool isReply}) {
    emit(state.copyWith(userName: userName ?? ownerName, isReply: isReply));
  }
}
