import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comment_reaction_box_hide_controller_state.dart';

class CommentReactionBoxHideControllerCubit
    extends Cubit<CommentReactionBoxHideControllerState> {
  CommentReactionBoxHideControllerCubit()
      : super(const CommentReactionBoxHideControllerState());

  void closeRectionBox() {
    //refresh the state
    emit(state.copyWith(visible: true));
    emit(state.copyWith(visible: false));
  }
}
