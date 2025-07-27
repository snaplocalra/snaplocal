import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_reaction_state.dart';

class ShowReactionCubit extends Cubit<ShowReactionState> {
  ShowReactionCubit() : super(const ShowReactionState());

  Future<void> showReactionEmojiOption({String? objectId}) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(showEmojiOption: true, objectId: objectId));
  }

  Future<void> closeReactionEmojiOption() async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(showEmojiOption: false));
  }
}
