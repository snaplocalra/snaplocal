import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_status.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/message_request_status_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/tools/chat_time_formatter.dart';
import 'package:snap_local/common/utils/firebase_chat/tools/firebase_content_type_extractor.dart';

class FirebaseChatRepository {
  final MessageRequestStatusRepository messageRequestStatusRepository;

  FirebaseChatRepository(this.messageRequestStatusRepository);

  final _firebaseFirestore = FirebaseFirestore.instance;
  final authSharedPref = AuthenticationTokenSharedPref();

  ///Initiate the user and other communication
  Future<CommunicationModel> initCommunication({
    required String receiverUserId,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      //Get the conversation data and convert it to the model
      //If the conversation does not exist then null will be returned
      final communicationData =
          await FirebaseChatCommunicationRepository().getCommunicationDetails(
        receiverUserId: receiverUserId,
        otherCommunicationPost: otherCommunicationPost,
      );

      //If the conversation is null then create a new communication
      if (communicationData == null) {
        final currentUserId = await authSharedPref.getUserId();

        //Get the user conversation reference
        final userConversation = _firebaseFirestore.collection(
          otherCommunicationPost != null
              ? FirebasePath.otherCommunication
              : FirebasePath.userCommunication,
        );

        //Get the conversation id
        final conversationId = userConversation.doc().id;

        //Get the conversation document
        final conversationDoc = userConversation.doc(conversationId);

        //Initial communication users for the new communication model
        final communicationUsers = [currentUserId, receiverUserId];

        //Default communication users analytics
        final communicationUsersAnalytics = communicationUsers
            .map(
              (userId) => CommunicationUsersAnalyticsModel(
                userId: userId,
                unseenMessageCount: 0,
              ),
            )
            .toList();

        late CommunicationModel communicationModel;
        //Other communication
        if (otherCommunicationPost != null) {
          //create the conversation model
          final otherCommunicationModel =
              otherCommunicationPost.createCommunication(
            communicationId: conversationId,
            users: communicationUsers,
            communicationUsersAnalytics: communicationUsersAnalytics,
          );

          //Assign the other communication model to the communication model
          communicationModel = otherCommunicationModel;
        }
        //User communication
        else {
          //Create the conversation model
          final neighboursCommunicationModel = CommunicationModel(
            communicationId: conversationId,
            users: communicationUsers,
            communicationUsersAnalytics: communicationUsersAnalytics,
          );

          //Assign the neighbours communication model to the communication model
          communicationModel = neighboursCommunicationModel;
        }

        //Create the communication on the firestore
        await conversationDoc.set(communicationModel.toMap());

        //Update the message request status
        await messageRequestStatusRepository.initializeMessageRequestStatus(
          communicationModel.communicationId,
          receiverUserId,
        );

        //Return the communication model
        return communicationModel;
      } else {
        return communicationData;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Streams
  Map<String, List<ConversationModel>> _groupMessageIsolate(
      List<ConversationModel> chatMessageList) {
    return groupBy<ConversationModel, String>(
        chatMessageList, (message) => formatChatTime(message.createdTime));
  }

  Stream<Map<String, List<ConversationModel>>?> streamConversationMessages({
    required String communicationId,
    required DateTime? lastChatDeleteTime,
    String? query,
    bool isOtherTypeConversation = false,
  }) async* {
    try {
      final currentUserId = await authSharedPref.getUserId();
      yield* _firebaseFirestore
          .collection(
            isOtherTypeConversation
                ? FirebasePath.otherCommunication
                : FirebasePath.userCommunication,
          )
          .doc(communicationId)
          .collection(FirebasePath.conversation)
          //Check that the lastChatDeleteTime is null or not, if null then allow all conversation
          //Otherwise, allow the conversation that is created after the lastChatDeleteTime
          .where(
            FirebaseField.createdTime,
            isGreaterThan: lastChatDeleteTime?.millisecondsSinceEpoch,
          )
          .orderBy(FirebaseField.createdTime, descending: true)
          .snapshots(includeMetadataChanges: true)
          .asyncMap((snaps) {
        //Filter the message based on the query
        final chatMessageList = snaps.docs
            .map(
              (doc) => ConversationModel.fromMap(
                doc.data(),
                currentUserId: currentUserId,
              ),
            ) //Remove the message that is sent by the receiver
            //when the sender blocked that receiver
            .whereNot((conversation) =>
                conversation.messageSentWhenBlocked &&
                !conversation.isCurrentUser)
            .where((conversation) {
          return query == null ||
              conversation.message.toLowerCase().contains(query.toLowerCase());
        }).toList();

        //Create message group and return
        return _groupMessageIsolate(chatMessageList);
      });
    } catch (error) {
      rethrow;
    }
  }

  ///
  Future<void> _updatedLastMessage({
    required String communicationId,
    required Map<String, dynamic> data,
    required bool isOtherTypeConversation,
  }) async {
    //Update the last message
    final communicationDoc = _firebaseFirestore
        .collection(
          _getConversationCommunicationPath(
            isOtherTypeConversation: isOtherTypeConversation,
          ),
        )
        .doc(communicationId);

    await communicationDoc.update(data);
  }

  //set the last message deleted status
  Future<void> setUserShowLastMessage({
    required String communicationId,
    required bool status,
    required bool isOtherTypeConversation,
    required String userId,
  }) async {
    //1. get communication data
    final communicationData =
        await FirebaseChatCommunicationRepository().getCommunicationById(
      communicationId: communicationId,
      isOtherCommunication: isOtherTypeConversation,
    );

    if (communicationData != null) {
      //2. update the communication data
      await _firebaseFirestore
          .collection(
            _getConversationCommunicationPath(
              isOtherTypeConversation: isOtherTypeConversation,
            ),
          )
          .doc(communicationId)
          .update({
        FirebaseField.communicationUsersAnalytics:
            communicationData.communicationUsersAnalytics.map((e) {
          if (e.userId == userId) {
            e = e.copyWith(showLastMessage: status);
          }
          return e.toMap();
        }).toList(),
      });
    }
  }

  ///Conversation communication path
  String _getConversationCommunicationPath(
      {required bool isOtherTypeConversation}) {
    return isOtherTypeConversation
        ? FirebasePath.otherCommunication
        : FirebasePath.userCommunication;
  }

  ///
  Future<void> _storeMessage({
    required ConversationModel conversationModel,
    required String communicationId,
    required bool isOtherTypeConversation,
  }) async {
    //Store the message
    return await _firebaseFirestore
        .collection(
          _getConversationCommunicationPath(
            isOtherTypeConversation: isOtherTypeConversation,
          ),
        )
        .doc(communicationId)
        .collection(FirebasePath.conversation)
        .doc(conversationModel.conversationId)
        .set(conversationModel.toMap());
  }

  Future<void> sendMessage({
    required ConversationModel conversationModel,
    required String communicationId,

    ///Other type conversation post implementation
    required bool isOtherTypeConversation,
  }) async {
    try {
      final conversationId = _firebaseFirestore
          .collection(
            _getConversationCommunicationPath(
              isOtherTypeConversation: isOtherTypeConversation,
            ),
          )
          .doc(communicationId)
          .collection(FirebasePath.conversation)
          .doc()
          .id;

      //Assign the conversation id to the conversation model
      final updatedConversationModel =
          conversationModel.copyWith(conversationId: conversationId);

      //Store message on the owner chat conversation
      await _storeMessage(
        conversationModel: updatedConversationModel,
        communicationId: communicationId,
        isOtherTypeConversation: isOtherTypeConversation,
      );

      //Update the last message
      await _updatedLastMessage(
        communicationId: communicationId,
        data: {
          FirebaseField.lastMessage: updatedConversationModel.toMap(),
          FirebaseField.isLastMessageDeleted: false,
        },
        isOtherTypeConversation: isOtherTypeConversation,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      ThemeToast.errorToast(e.toString());
    }
  }

  //update the message status
  Future<void> updateMessageStatus({
    required String conversationId,
    required String communicationId,
    required MessageStatusInfo messageStatusInfo,
    required bool isOtherTypeConversation,
  }) async {
    try {
      final conversation = _firebaseFirestore
          .collection(
            _getConversationCommunicationPath(
              isOtherTypeConversation: isOtherTypeConversation,
            ),
          )
          .doc(communicationId)
          .collection(FirebasePath.conversation)
          .doc(conversationId);

      //Update the message status
      return await conversation.update(
        {FirebaseField.messageStatusInfo: messageStatusInfo.toMap()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      ThemeToast.errorToast(e.toString());
    }
  }

  //Delete the message
  Future<void> deleteMessage({
    required ConversationModel conversationModel,
    required CommunicationModel communicationModel,
    required bool isDeleteForMe,
    required bool isLastMessage,
    required bool isOtherTypeConversation,
  }) async {
    try {
      final senderId = await authSharedPref.getUserId();

      //check whether the message delete option is Delete for me
      isDeleteForMe
          ? conversationModel.deletedFor.add(communicationModel.users
              .firstWhere((element) => element == senderId))

          //If the message delete option is  Delete for everyone,
          : conversationModel.deletedFor
              .addAll(communicationModel.users.map((e) => e));

      //Update the conversation model on the firestore
      await _firebaseFirestore
          .collection(
            isOtherTypeConversation
                ? FirebasePath.otherCommunication
                : FirebasePath.userCommunication,
          )
          .doc(communicationModel.communicationId)
          .collection(FirebasePath.conversation)
          .doc(conversationModel.conversationId)
          .update(conversationModel.toMap());

      //Update the last message
      await _updatedLastMessage(
        communicationId: communicationModel.communicationId,
        data: {FirebaseField.isLastMessageDeleted: isLastMessage},
        isOtherTypeConversation: isOtherTypeConversation,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  //Increase unread message count
  Future<void> increaseUnseenCount({
    required String userId,
    required String communicationId,
    bool isOtherTypeConversation = false,
  }) async {
    //Get the communication data
    final communication =
        await FirebaseChatCommunicationRepository().getCommunicationById(
      communicationId: communicationId,
      isOtherCommunication: isOtherTypeConversation,
    );

    if (communication != null) {
      final communicationPath = isOtherTypeConversation
          ? FirebasePath.otherCommunication
          : FirebasePath.userCommunication;

      //push data to the firestore
      await _firebaseFirestore
          .collection(communicationPath)
          .doc(communicationId)
          .update({
        FirebaseField.communicationUsersAnalytics:
            communication.communicationUsersAnalytics.map((e) {
          if (e.userId == userId) {
            e = e.copyWith(unseenMessageCount: e.unseenMessageCount + 1);
          }
          return e.toMap();
        }).toList(),
      });
    }
  }

  //Set unread message count to zero
  Future<void> setUnseenCountToZero({
    required String userId,
    required String communicationId,
    bool isOtherTypeConversation = false,
  }) async {
    final latestCommunication =
        await FirebaseChatCommunicationRepository().getCommunicationById(
      communicationId: communicationId,
      isOtherCommunication: isOtherTypeConversation,
    );

    if (latestCommunication != null) {
      final communicationPath = isOtherTypeConversation
          ? FirebasePath.otherCommunication
          : FirebasePath.userCommunication;

      //push data to the firestore
      await _firebaseFirestore
          .collection(communicationPath)
          .doc(communicationId)
          .update({
        FirebaseField.communicationUsersAnalytics:
            latestCommunication.communicationUsersAnalytics.map((e) {
          if (e.userId == userId) {
            e = e.copyWith(unseenMessageCount: 0);
          }
          return e.toMap();
        }),
      });
    }
  }

  //Update user online status
  Future<void> updateUserOnlineStatus({
    required bool isOnline,
    required String userId,
    required String communicationId,
    bool isOtherTypeConversation = false,
  }) async {
    final latestCommunication =
        await FirebaseChatCommunicationRepository().getCommunicationById(
      communicationId: communicationId,
      isOtherCommunication: isOtherTypeConversation,
    );

    if (latestCommunication != null) {
      final communicationPath = isOtherTypeConversation
          ? FirebasePath.otherCommunication
          : FirebasePath.userCommunication;

      //push data to the firestore
      await _firebaseFirestore
          .collection(communicationPath)
          .doc(communicationId)
          .update({
        FirebaseField.communicationUsersAnalytics:
            latestCommunication.communicationUsersAnalytics.map((e) {
          if (e.userId == userId) {
            e = e.copyWith(isOnline: isOnline);
          }
          return e.toMap();
        }),
      });
    }
  }

  //Upload file to file store
  Future<String> uploadFileToServer({
    required File pickedFile,
    required String fileName,
    required String communicationId,
  }) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child(FirebaseField.documents)
          .child(communicationId)
          .child(fileName);

      final contentType = firebaseContentTypeFromFile(pickedFile);
      await ref.putFile(pickedFile, SettableMetadata(contentType: contentType));
      return await ref.getDownloadURL();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }
}
