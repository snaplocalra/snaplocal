import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chat_blocked_users_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chats_repository.dart';

class FirebaseChatSettingRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final authSharedPref = AuthenticationTokenSharedPref();
  LocalChatBlockedUsersRepository localChatsBlockedRepo=LocalChatBlockedUsersRepository();


  Stream<bool> streamBlockStatus({
    required String primaryUserId,
    required String secondaryUserId,
  }) async* {
    yield* _firebaseFirestore
        .collection(FirebasePath.userList)
        .doc(primaryUserId)
        .snapshots()
        .map(
          (event) => FirebaseUserProfileDetailsModel.fromJson(event.data()!)
              .blockedUsers
              .contains(secondaryUserId),
        );
  }

  Future<bool> checkBlockStatus({
    required String primaryUserId,
    required String secondaryUserId,
  }) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.userList)
          .doc(primaryUserId)
          .get()
          .then(
            (value) => FirebaseUserProfileDetailsModel.fromJson(value.data()!)
                .blockedUsers
                .contains(secondaryUserId),
          );
    } catch (error) {
      rethrow;
    }
  }

  //Toggle block the receiver user
  Future<void> toggleUserBlock(String receiverUserId) async {
    try {
      final senderId = await authSharedPref.getUserId();

      final senderUserDocRef =
          _firebaseFirestore.collection(FirebasePath.userList).doc(senderId);

      final senderUserData = await senderUserDocRef.get().then(
          (value) => FirebaseUserProfileDetailsModel.fromJson(value.data()!));

      final isBlocked = senderUserData.blockedUsers.contains(receiverUserId);
      print("isBlocked: $isBlocked");

      if (isBlocked) {
        //If blocked then remove the receiver user id from the blocked users list
        senderUserData.blockedUsers.remove(receiverUserId);
        await localChatsBlockedRepo.updateUnblockHistory(senderId,receiverUserId);
      } else {
        //If not block then add the receiver user id to the blocked users list
        senderUserData.blockedUsers.add(receiverUserId);
        if(!senderUserData.blockedUsersHistory.contains(receiverUserId)) {
          senderUserData.blockedUsersHistory.add(receiverUserId);
        }
        await localChatsBlockedRepo.addBlockHistory(senderId,receiverUserId);
      }

      //Update the user profile data
      await senderUserDocRef.update(senderUserData.toJson());
    } catch (e) {
      // Record the error in Firebase Crashlytics
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  ///Check the target user is blocked the current user or not
  Future<bool> fetchBlockStatus({required String targetUserId}) async {
    try {
      //Get the current user id
      final currentUserId = await authSharedPref.getUserId();

      //Get the user profile data
      final userData =
          await FirebaseUserRepository().fetchUserData(userId: targetUserId);

      if (userData == null) {
        //If the user profile is null then return false
        throw "User not found";
      }

      //If the user blocked the viewer then return true
      return userData.blockedUsers.contains(currentUserId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }
}
