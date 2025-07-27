import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'send_comment_state.dart';

class SendCommentCubit extends Cubit<SendCommentState> {
  SendCommentCubit() : super(PostCommentInitial());

  void onComment(String comment) {
    emit(OnComment(comment));
  }
}
