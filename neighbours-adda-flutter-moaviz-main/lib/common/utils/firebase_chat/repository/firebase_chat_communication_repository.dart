import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/neighbours_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/other_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';

class FirebaseChatCommunicationRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final authSharedPref = AuthenticationTokenSharedPref();

  SortFilterType? getSortFilterType(String? filter) {
    if (filter == null || filter.isEmpty) {
      return null;
    } else {
      final filterDecode = jsonDecode(filter);
      final sortBy = filterDecode["sort_by"];
      if (sortBy == null) {
        return null;
      }
      return SortFilterType.fromJson(sortBy);
    }
  }

  //User based chat
  Stream<List<ChatContactModel>?> streamUserChatContacts({
    String? query,
    String? filter,
  }) async* {
    try {
      final senderId = await authSharedPref.getUserId();

      //Filter data
      SortFilterType? sortFilterType = getSortFilterType(filter);

      yield* _firebaseFirestore
          .collection(FirebasePath.userCommunication)
          .where(FirebaseField.users, arrayContains: senderId)
          .where(
            "${FirebaseField.lastMessage}.${FirebaseField.createdTime}",
            isNull: false,
          )
          .orderBy(
            //Created time is inside the last message
            "${FirebaseField.lastMessage}.${FirebaseField.createdTime}",
            descending:
                sortFilterType == SortFilterType.oldMessages ? false : true,
          )
          .snapshots()
          .map(
            (event) => List<CommunicationModel>.from(
              event.docs.map(
                (e) => CommunicationModel.fromMap(
                  e.data(),
                  currentUserId: senderId,
                ),
              ),
            ),
          )
          .asyncMap((communicationList) async {
        final chatContactList = <ChatContactModel>[];

        for (var communication in communicationList) {
          //Check the communication is visible for the current user
          final isCommunicationVisible = communication
              .communicationUsersAnalytics
              .firstWhere((element) => element.userId == senderId)
              .isCommunicationVisilbe;
          if (!isCommunicationVisible) {
            //If the communication is not visible then continue to the next communication
            continue;
          }

          final receiverUserId =
              communication.users.firstWhere((element) => element != senderId);

          final receiverUserData = await FirebaseUserRepository()
              .fetchUserData(userId: receiverUserId);

          if (receiverUserData == null) {
            //If the user profile is null then continue to the next user
            continue;
          } else {
            final isBlockedByReceiver = await FirebaseChatSettingRepository()
                .fetchBlockStatus(targetUserId: receiverUserId);
            if (query == null ||
                receiverUserData.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              final chatContactModel = NeighboursChatContact(
                contactId: receiverUserId,
                contactImage: receiverUserData.profileImage,
                contactTitle: receiverUserData.name,
                communicationModel: communication,
                isBlockedByReceiver: isBlockedByReceiver,
                isLastMessageDeleted: communication.isLastMessageDeleted,
                //Get the unread message count for the current user
                unreadMessageCount: communication.communicationUsersAnalytics
                    .firstWhere((element) => element.userId == senderId)
                    .unseenMessageCount,
              );
              chatContactList.add(chatContactModel);
            }
          }
        }

        //order the chat list based on the unread message count from high to low
        if (sortFilterType == SortFilterType.unread) {
          chatContactList.sort(
            (a, b) => b.unreadMessageCount.compareTo(a.unreadMessageCount),
          );
        }

        return chatContactList;
      });
    } catch (error) {
      FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
      ThemeToast.errorToast(error.toString());
    }
  }

  //Other chat
  Stream<List<ChatContactModel>?> streamOtherChatContacts({
    String? query,
    String? filter,
  }) async* {
    try {
      final senderId = await authSharedPref.getUserId();

      //Filter data
      SortFilterType? sortFilterType = getSortFilterType(filter);

      yield* _firebaseFirestore
          .collection(FirebasePath.otherCommunication)
          .where(FirebaseField.users, arrayContains: senderId)
          .where(
            "${FirebaseField.lastMessage}.${FirebaseField.createdTime}",
            isNull: false,
          )
          .orderBy(
            //Created time is inside the last message
            "${FirebaseField.lastMessage}.${FirebaseField.createdTime}",
            descending:
                sortFilterType == SortFilterType.oldMessages ? false : true,
          )
          .snapshots()
          .map((event) => List<OtherCommunicationModel>.from(
                event.docs.map(
                  (e) => OtherCommunicationModel.fromMap(
                    e.data(),
                    currentUserId: senderId,
                  ),
                ),
              ))
          .asyncMap((otherCommunicationList) async {
        final chatContactList = <ChatContactModel>[];

        for (var otherCommunication in otherCommunicationList) {
          //Check the communication is visible for the current user
          final isCommunicationVisible = otherCommunication
              .communicationUsersAnalytics
              .firstWhere((element) => element.userId == senderId)
              .isCommunicationVisilbe;
          if (!isCommunicationVisible) {
            //If the communication is not visible then continue to the next communication
            continue;
          }

          final receiverUserId = otherCommunication.users
              .firstWhere((element) => element != senderId);

          final receiverUserData = await FirebaseUserRepository()
              .fetchUserData(userId: receiverUserId);

          if (receiverUserData == null) {
            //If the user profile is null then continue to the next user
            continue;
          } else {
            final isBlockedByReceiver = await FirebaseChatSettingRepository()
                .fetchBlockStatus(targetUserId: receiverUserId);
            if (query == null ||
                receiverUserData.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              OtherChatContactModel otherCommunicationModel =
                  OtherChatContactModel.create(
                currentUserId: senderId,
                contactId: receiverUserId,
                contactImage: receiverUserData.profileImage,
                contactTitle: receiverUserData.name,
                otherCommunicationModel: otherCommunication,
                isBlockedByReceiver: isBlockedByReceiver,
                isLastMessageDeleted: otherCommunication.isLastMessageDeleted,

                //Get the unread message count for the current user
                unreadMessageCount: otherCommunication
                    .communicationUsersAnalytics
                    .firstWhere((element) => element.userId == senderId)
                    .unseenMessageCount,
              );
              otherCommunicationModel =
                  await otherCommunicationModel.fetchDataFromServer();
              chatContactList.add(otherCommunicationModel);
            }
          }
        }

        //order the chat list based on the unread message count from high to low
        if (sortFilterType == SortFilterType.unread) {
          chatContactList.sort(
              (a, b) => b.unreadMessageCount.compareTo(a.unreadMessageCount));
        }
        return chatContactList;
      });
    } catch (error) {
      FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
      ThemeToast.errorToast(error.toString());
    }
  }

  //Find the Communication
  Future<CommunicationModel?> getCommunicationDetails({
    required String receiverUserId,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async {
    try {
      final currentUserId = await authSharedPref.getUserId();

      //Get the user conversation reference
      final communicationPath = _firebaseFirestore.collection(
        otherCommunicationPost != null
            ? FirebasePath.otherCommunication
            : FirebasePath.userCommunication,
      );

      //Get the conversation data and convert it to the model
      //If the conversation does not exist then null will be returned
      return await communicationPath
          .where(
            FirebaseField.users,
            whereIn: [
              [currentUserId, receiverUserId],
              [receiverUserId, currentUserId],
            ],
          )
          //Check the other communication id if it is available
          .where(
            "${FirebaseField.otherCommunicationDetails}.id",
            isEqualTo: otherCommunicationPost?.id,
          )
          .limit(1) //limit the result to 1 document
          .get()
          .then((value) => value.docs.isNotEmpty
              ? otherCommunicationPost != null
                  ? OtherCommunicationModel.fromMap(
                      value.docs.first.data(),
                      currentUserId: currentUserId,
                    )
                  : CommunicationModel.fromMap(value.docs.first.data())
              : null);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Find the Communication by id
  Future<CommunicationModel?> getCommunicationById({
    required String communicationId,
    required bool isOtherCommunication,
  }) async {
    try {
      //Get the user conversation reference
      final communicationPath = _firebaseFirestore.collection(
        isOtherCommunication
            ? FirebasePath.otherCommunication
            : FirebasePath.userCommunication,
      );

      //Get the conversation data and convert it to the model
      //If the conversation does not exist then null will be returned
      return await communicationPath.doc(communicationId).get().then(
            (value) =>
                value.exists ? CommunicationModel.fromMap(value.data()!) : null,
          );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Communication model stream
  Stream<CommunicationModel?> streamCommunicationModel({
    required String receiverUserId,
    required OtherCommunicationPost? otherCommunicationPost,
  }) async* {
    try {
      final currentUserId = await authSharedPref.getUserId();

      //Get the user conversation reference
      final communicationPath = _firebaseFirestore.collection(
        otherCommunicationPost != null
            ? FirebasePath.otherCommunication
            : FirebasePath.userCommunication,
      );

      yield* communicationPath
          .where(
            FirebaseField.users,
            whereIn: [
              [currentUserId, receiverUserId],
              [receiverUserId, currentUserId],
            ],
          )
          //Check the other communication id if it is available
          .where(
            "${FirebaseField.otherCommunicationDetails}.id",
            isEqualTo: otherCommunicationPost?.id,
          )
          .limit(1)
          .snapshots()
          .map(
            (event) => event.docs.isNotEmpty
                ? otherCommunicationPost != null
                    ? OtherCommunicationModel.fromMap(
                        event.docs.first.data(),
                        currentUserId: currentUserId,
                      )
                    : CommunicationModel.fromMap(event.docs.first.data())
                : null,
          );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Stream the count of unread message from both user communication and other communication snapshot
  Stream<int> streamCurrentUserUnreadMessageCount() async* {
    final currentUserId = await authSharedPref.getUserId();

    // User communication
    final userUnreadMessageCountStream = _firebaseFirestore
        .collection(FirebasePath.userCommunication)
        .where(FirebaseField.users, arrayContains: currentUserId)
        .where(FirebaseField.lastMessage, isNull: false)
        .snapshots(includeMetadataChanges: true)
        .map((event) => event.docs.map((e) => CommunicationModel.fromMap(
              e.data(),
              currentUserId: currentUserId,
            )))
        .asyncMap((userCommunicationList) async {
      int userUnreadMessageCount = 0;
      for (var element in userCommunicationList) {
        userUnreadMessageCount += element.communicationUsersAnalytics
            .firstWhere((element) => element.userId == currentUserId)
            .unseenMessageCount;
      }
      return userUnreadMessageCount;
    }).handleError((error) {
      return 0; // Return 0 in case of an error
    });

    // Other communication
    final otherUnreadMessageCountStream = _firebaseFirestore
        .collection(FirebasePath.otherCommunication)
        .where(FirebaseField.users, arrayContains: currentUserId)
        .where(FirebaseField.lastMessage, isNull: false)
        .snapshots(includeMetadataChanges: true)
        .map((event) => event.docs.map((e) => OtherCommunicationModel.fromMap(
              e.data(),
              // currentUserId: currentUserId,
            )))
        .asyncMap((otherCommunicationList) async {
      int otherUnreadMessageCount = 0;
      for (var element in otherCommunicationList) {
        otherUnreadMessageCount += element.communicationUsersAnalytics
            .firstWhere((element) => element.userId == currentUserId)
            .unseenMessageCount;
      }
      return otherUnreadMessageCount;
    }).handleError((error) {
      return 0; // Return 0 in case of an error
    });

    // Combine both streams
    final combinedStream = CombineLatestStream.combine2(
      userUnreadMessageCountStream,
      otherUnreadMessageCountStream,
      (int userCount, int otherCount) => userCount + otherCount,
    );

    // Listen to the combined stream
    await for (final totalCount in combinedStream) {
      yield totalCount;
    }
  }

  // Set the last_chat delete time on the communication model users analytics
  Future<void> setLastChatDeleteTime({
    required String userId,
    required String communicationId,
    required bool isOtherCommunication,
  }) async {
    try {
      //Communication users analytics

      final communicationModel = await getCommunicationById(
        communicationId: communicationId,
        isOtherCommunication: isOtherCommunication,
      );

      if (communicationModel != null) {
        //Get the user conversation reference
        final communicationPath = _firebaseFirestore.collection(
          isOtherCommunication
              ? FirebasePath.otherCommunication
              : FirebasePath.userCommunication,
        );
        //Update the communication visibility on the firebase
        await communicationPath.doc(communicationId).update(
          {
            FirebaseField.communicationUsersAnalytics:
                communicationModel.communicationUsersAnalytics.map((e) {
              if (e.userId == userId) {
                e = e.copyWith(lastChatDeleteTime: DateTime.now());
              }

              return e.toMap();
            }),
          },
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Set the communication visibility
  Future<void> setCommunicationVisibility({
    required String userId,
    required String communicationId,
    bool isOtherCommunication = false,
    required bool visible,
  }) async {
    try {
      final latestCommunicationModel = await getCommunicationById(
        communicationId: communicationId,
        isOtherCommunication: isOtherCommunication,
      );

      if (latestCommunicationModel != null) {
        //Get the user conversation reference
        final communicationPath = _firebaseFirestore.collection(
          isOtherCommunication
              ? FirebasePath.otherCommunication
              : FirebasePath.userCommunication,
        );

        //Update the communication visibility on the firebase
        await communicationPath.doc(communicationId).update(
          {
            FirebaseField.communicationUsersAnalytics:
                latestCommunicationModel.communicationUsersAnalytics.map((e) {
              if (e.userId == userId) {
                e = e.copyWith(isCommunicationVisilbe: visible);
              }
              return e.toMap();
            }),
          },
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }
}
