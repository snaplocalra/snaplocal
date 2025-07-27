import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';

part 'chat_contact_state.dart';

class ChatContactCubit extends Cubit<ChatContactState> {
  final FirebaseChatCommunicationRepository firebaseChatContactRepository;
  final FirebaseChatRepository firebaseChatRepository;

  ChatContactCubit({
    required this.firebaseChatContactRepository,
    required this.firebaseChatRepository,
  }) : super(const ChatContactState());

  //User based chat
  Stream<List<ChatContactModel>?> streamUserChatContacts({
    String? query,
    String? filter,
  }) {
    return firebaseChatContactRepository.streamUserChatContacts(
      query: query,
      filter: filter,
    );
  }

  //Other chat
  Stream<List<ChatContactModel>?> streamOtherChatContacts({
    String? query,
    String? filter,
  }) {
    return firebaseChatContactRepository.streamOtherChatContacts(
      query: query,
      filter: filter,
    );
  }

  //Set the communication visibility to true only when the message is sent and
  //the communication is not visible
  Future<void> setCommunicationVisibility({
    required bool visible,
    required CommunicationModel communicationModel,
    bool isOtherCommunication = false,
  }) async {
    // Check for the communication visibility status for both users
    for (var user in communicationModel.communicationUsersAnalytics) {
      // If the communication is not visible, then set the communication visibility to true
      if (!user.isCommunicationVisilbe) {
        await firebaseChatContactRepository.setCommunicationVisibility(
          userId: user.userId,
          communicationId: communicationModel.communicationId,
          isOtherCommunication: isOtherCommunication,
          visible: visible,
        );
      }
    }
  }

  //Delete chat
  Future<void> deleteChat({
    required CommunicationModel communicationModel,
    required bool isOtherCommunication,
  }) async {
    try {
      final currentUserId = await AuthenticationTokenSharedPref().getUserId();

      emit(state.copyWith(chatDeleteLoading: true));

      //clean chat
      await clearChat(
        communicationModel: communicationModel,
        isOtherCommunication: isOtherCommunication,
      );

      //Disable the communication visibility
      await firebaseChatContactRepository.setCommunicationVisibility(
        userId: currentUserId,
        communicationId: communicationModel.communicationId,
        isOtherCommunication: isOtherCommunication,
        visible: false,
      );

      emit(state.copyWith(chatDeleteSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }

  //clear chat
  Future<void> clearChat({
    required CommunicationModel communicationModel,
    required bool isOtherCommunication,
  }) async {
    try {
      final currentUserId = await AuthenticationTokenSharedPref().getUserId();

      emit(state.copyWith(chatCleanLoading: true));

      //Set the user last chat delete time
      await firebaseChatContactRepository.setLastChatDeleteTime(
        userId: currentUserId,
        communicationId: communicationModel.communicationId,
        isOtherCommunication: isOtherCommunication,
      );

      // Set the unseen count to zero for the current user
      await firebaseChatRepository.setUnseenCountToZero(
        userId: currentUserId,
        communicationId: communicationModel.communicationId,
        isOtherTypeConversation: isOtherCommunication,
      );

      // Set the last message deleted status to true
      await firebaseChatRepository.setUserShowLastMessage(
        communicationId: communicationModel.communicationId,
        status: false,
        isOtherTypeConversation: isOtherCommunication,
        userId: currentUserId,
      );

      emit(state.copyWith(chatCleanSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }
}
