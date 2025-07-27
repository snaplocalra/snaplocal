
import 'package:bloc/bloc.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_model.dart';

class ReplyCubit extends Cubit<LocalChatModel?> {
  ReplyCubit() : super(null);

  void setReplyTo(LocalChatModel message) {
    print('Replying to ${message.message}');
    emit(message);
  }
  void clearReply() => emit(null);
}