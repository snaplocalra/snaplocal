// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:designer/utility/theme_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_setting/chat_setting_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_status.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/send_chat_notification_repository.dart';
import 'package:snap_local/common/utils/models/route_navigation_model.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:video_compress/video_compress.dart';

part 'chat_controller_state.dart';

class ChatControllerCubit extends Cubit<ChatControllerState> {
  final DataUploadStatusCubit dataUploadStatusCubit;
  final FirebaseChatRepository firebaseChatRepository;
  ChatControllerCubit({
    required this.dataUploadStatusCubit,
    required this.firebaseChatRepository,
  }) : super(const ChatControllerState());

  final firebaseUserRepository = FirebaseUserRepository();
  final authSharedPref = AuthenticationTokenSharedPref();

  Stream<Map<String, List<ConversationModel>>?> streamConversationMessages({
    String? query,
    required String communicationId,
    required DateTime? lastChatDeleteTime,
    required OtherCommunicationPost? otherCommunicationPost,
  }) =>
      firebaseChatRepository.streamConversationMessages(
        query: query,
        communicationId: communicationId,
        lastChatDeleteTime: lastChatDeleteTime,
        isOtherTypeConversation: otherCommunicationPost != null,
      );

  ///Initiate the conversation with the receiver
  Future<CommunicationModel> initConversation({
    required String receiverUserId,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      emit(state.copyWith(chatInitLoading: true));

      final communicationModel = await firebaseChatRepository.initCommunication(
        receiverUserId: receiverUserId,
        otherCommunicationPost: otherCommunicationPost,
      );

      emit(state.copyWith(communicationModel: communicationModel));
      return communicationModel;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      rethrow;
    }
  }

  //Set the communication visibility to true only when the message is sent and
  //the communication is not visible
  Future<void> _setCommunicationVisibility({
    required bool visible,
    required CommunicationModel communicationModel,
    required bool isOtherCommunication,
  }) async {
    try {
      // Check for the communication visibility status for both users
      for (var user in communicationModel.communicationUsersAnalytics) {
        // If the communication is not visible, then set the communication visibility to true
        if (!user.isCommunicationVisilbe) {
          await FirebaseChatCommunicationRepository()
              .setCommunicationVisibility(
            userId: user.userId,
            communicationId: communicationModel.communicationId,
            isOtherCommunication: isOtherCommunication,
            visible: visible,
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  ///send chat message from outside the chat screen
  Future<void> sendExternalChatMessage({
    required String receiverUserId,
    required String message,
    SocialPostModel? socialPostModel,
    MessageType messageType = MessageType.text,
    OtherCommunicationPost? otherCommunicationPost,
    bool showSuccessToast = true,
  }) async {
    try {
      emit(state.copyWith(messageSendLoading: true));
      final chatSettingCubit = ChatSettingCubit(
        firebaseChatRepository: firebaseChatRepository,
        firebaseChatSettingRepository: FirebaseChatSettingRepository(),
      );
      final isMessageBlockedByEitherParty = await chatSettingCubit
          .isMessageBlockedByEitherParty(receiverUserId: receiverUserId);

      if (isMessageBlockedByEitherParty) {
        emit(state.copyWith());
        return;
      } else {
        //initiate the conversation
        final communicationModel = await initConversation(
          receiverUserId: receiverUserId,
          otherCommunicationPost: otherCommunicationPost,
        );

        //Set the communication visibility to true only when the message is sent
        await _setCommunicationVisibility(
          visible: true,
          communicationModel: communicationModel,
          isOtherCommunication: otherCommunicationPost != null,
        );

        //Send the message
        await sendMessage(
          message: message,
          messageType: messageType,
          receiverUserId: receiverUserId,
          socialPostModel: socialPostModel,
          communication: communicationModel,

          // The receiverBlockedSender parameter will always be false here because, before reaching this method,
          // we have already checked for block status, and if any block status is found true,
          // this method will not be called.
          receiverBlockedSender: false,

          //If true then the conversation will be of other type conversation
          otherCommunicationPost: otherCommunicationPost,
        );
        if (isClosed) {
          return;
        }
        emit(state.copyWith(
          isSendMessageRequestSuccess: true,
          messageSendLoading: false,
        ));

        if (showSuccessToast) {
          ThemeToast.successToast(tr(LocaleKeys.messagesentsuccessfully));
        }
        return;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  //Send the message
  Future<void> sendMessage({
    //The communication
    required CommunicationModel communication,

    ///The message to be sent
    required String message,

    ///The type of message to be sent
    required MessageType messageType,

    ///If the receiver blocked the sender then do not send the notification
    required bool receiverBlockedSender,

    ///The user id of the receiver to send the notification
    required String receiverUserId,

    ///The file to be uploaded
    File? file,

    ///The social post model to be sent
    SocialPostModel? socialPostModel,

    ///Other type conversation post implementation
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      //Handle file upload
      ConversationFileModel? conversationFileModel;
      if (file != null) {
        //For file upload show loading
        dataUploadStatusCubit.show();

        final fileName = path.basename(file.path);
        final fileUrl = await firebaseChatRepository.uploadFileToServer(
          pickedFile: file,
          fileName: fileName,
          communicationId: communication.communicationId,
        );

        String? fileThumbnailUrl;
        if (messageType == MessageType.video) {
          final videoThumbnail = await VideoCompress.getFileThumbnail(file.path,
              quality: 50, // default(100)
              position: -1 // default(-1)
              );
          final videoThumbnailName =
              "Thumbnail_${path.basename(videoThumbnail.path)}";
          fileThumbnailUrl = await firebaseChatRepository.uploadFileToServer(
            pickedFile: videoThumbnail,
            fileName: videoThumbnailName,
            communicationId: communication.communicationId,
          );
        }

        //Assign the file details
        conversationFileModel = ConversationFileModel(
          fileUrl: fileUrl,
          fileName: fileName,
          fileThumbnailUrl: fileThumbnailUrl,
        );
        //stop loading
        dataUploadStatusCubit.stop();
      }
      //

      await firebaseChatRepository.sendMessage(
        communicationId: communication.communicationId,
        isOtherTypeConversation: otherCommunicationPost != null,
        conversationModel: ConversationModel(
          message: message,
          createdTime: DateTime.now(),
          conversationFileModel: conversationFileModel,
          messageType: messageType,
          messageSentWhenBlocked: receiverBlockedSender,
          socialPostModel: socialPostModel,
          senderId: await authSharedPref.getUserId(),
          receiverId: receiverUserId,
          messageStatusInfo: MessageStatusInfo(
            status: MessageStatus.sent,
            time: DateTime.now(),
          ),
        ),
      );

      //change the show last message status to true for both users if it is false
      for (var user in communication.communicationUsersAnalytics) {
        if (!user.showLastMessage) {
          await firebaseChatRepository.setUserShowLastMessage(
            userId: user.userId,
            communicationId: communication.communicationId,
            status: true,
            isOtherTypeConversation: otherCommunicationPost != null,
          );
        }
      }

      //If the receiver blocked the sender then do not send the notification and
      //not able to update the unread message count
      if (!receiverBlockedSender && !communication.isAllUsersOnline) {
        //Increase the unread message count
        await firebaseChatRepository.increaseUnseenCount(
          userId: receiverUserId,
          communicationId: communication.communicationId,
          isOtherTypeConversation: otherCommunicationPost != null,
        );

        await SendChatNotificationRepository().sendChatNotification(
          message: message,
          receiverUserId: receiverUserId,
          otherCommunicationChatNavigationDetailsModel:
              otherCommunicationPost != null
                  ? OtherCommunicationChatNavigationDetailsModel(
                      id: otherCommunicationPost.id,
                      otherCommunicationType:
                          otherCommunicationPost.otherCommunicationType,
                    )
                  : null,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  //Update the message status
  Future<void> updateMessageStatus({
    required String conversationId,
    required CommunicationModel communication,
    required MessageStatusInfo messageStatusInfo,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      await firebaseChatRepository.updateMessageStatus(
        conversationId: conversationId,
        communicationId: communication.communicationId,
        messageStatusInfo: messageStatusInfo,
        isOtherTypeConversation: otherCommunicationPost != null,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  //Delete the message
  Future<void> deleteMessage({
    required CommunicationModel communicationModel,
    required ConversationModel conversationModel,
    required String receiverUserId,
    required bool isDeleteForMe,
    bool isLastMessage = false,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      await firebaseChatRepository.deleteMessage(
        isDeleteForMe: isDeleteForMe,
        isLastMessage: isLastMessage,
        conversationModel: conversationModel,
        communicationModel: communicationModel,
        isOtherTypeConversation: otherCommunicationPost != null,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
