import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/blocked_user_history_model.dart';

class LocalChatBlockedUsersRepository {
  final _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'local_chat_blocked_users';

  // Future<void> blockUser({
  //   required String blockerId,
  //   required String blockedUserId,
  //   required String blockedUserName,
  //   String? blockedUserProfileImage,
  // }) async {
  //   final docRef = _firestore
  //       .collection(_collectionPath)
  //       .doc(blockerId)
  //       .collection('blocked')
  //       .doc(blockedUserId);

  //   await docRef.set({
  //     'blockedUserId': blockedUserId,
  //     'blockedUserName': blockedUserName,
  //     'blockedUserProfileImage': blockedUserProfileImage,
  //     'blockedAt': Timestamp.now(),
  //   });
  // }

  // Future<void> unblockUser({
  //   required String blockerId,
  //   required String blockedUserId,
  // }) async {
  //   await _firestore
  //       .collection(_collectionPath)
  //       .doc(blockerId)
  //       .collection('blocked')
  //       .doc(blockedUserId)
  //       .delete();
  // }

  // Future<bool> isUserBlocked({
  //   required String blockerId,
  //   required String blockedUserId,
  // }) async {
  //   final doc = await _firestore
  //       .collection(_collectionPath)
  //       .doc(blockerId)
  //       .collection('blocked')
  //       .doc(blockedUserId)
  //       .get();

  //   return doc.exists;
  // }

  Stream<List<String>> getBlockedUserIds(String userId) {
    print('Fetching blocked users for userId: $userId'); // Add logging
    return _firestore
        .collection(FirebasePath.userList)  // Changed from user_list_dev to users_list_dev
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          print('Snapshot data: ${snapshot.data()}'); // Add logging
          if (!snapshot.exists || !snapshot.data()!.containsKey('blocked_users_history')) {
            print('No blocked users found'); // Add logging
            return <String>[];
          }
          final List<dynamic> blockedUsers = snapshot.data()!['blocked_users_history'] ?? [];
          print('Found blocked users: $blockedUsers'); // Add logging
          return blockedUsers.map((user) => user.toString()).toList();
        });
  }

  Stream<List<String>> getBlockedHistoryUserIds(String userId) {
    print('Fetching blocked users for userId: $userId'); // Add logging
    return _firestore
        .collection(FirebasePath.userList)  // Changed from user_list_dev to users_list_dev
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          print('Snapshot data: ${snapshot.data()}'); // Add logging
          if (!snapshot.exists || !snapshot.data()!.containsKey('blocked_users_history')) {
            print('No blocked users found'); // Add logging
            return <String>[];
          }
          final List<dynamic> blockedUsers = snapshot.data()!['blocked_users_history'] ?? [];
          print('Found blocked users: $blockedUsers'); // Add logging
          return blockedUsers.map((user) => user.toString()).toList();
        });
  }

  // Add new methods for blocked users history
  Future<void> addBlockHistory(String userId, String blockedUserId) async {
    print('Adding block history for userId: $userId, blockedUserId: $blockedUserId');
    await _firestore
        .collection(FirebasePath.userList)
        .doc(userId)
        .collection(FirebasePath.blockedUsersHistory)
        .add({
          'blockedUserId': blockedUserId,
          'blockedAt': DateTime.now().toIso8601String(),
          'unblockedAt': null,
        });
  }

  Future<void> updateUnblockHistory(String userId, String blockedUserId) async {
    final querySnapshot = await _firestore
        .collection(FirebasePath.userList)
        .doc(userId)
        .collection(FirebasePath.blockedUsersHistory)
        .where('blockedUserId', isEqualTo: blockedUserId)
        .where('unblockedAt', isNull: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'unblockedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Stream<List<BlockedUserHistoryModel>> getBlockHistory(
      String userId) {
    return _firestore
        .collection(FirebasePath.userList)
        .doc(userId)
        .collection(FirebasePath.blockedUsersHistory)
        //.where('blockedUserId', isEqualTo: blockedUserId)
        .orderBy('blockedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BlockedUserHistoryModel.fromMap(doc.data()))
            .toList());
  }

  bool isMessageAllowed(String messageTimestamp, List<BlockedUserHistoryModel> blockHistory) {
    final messageTime = DateTime.parse(messageTimestamp);
    
    for (var history in blockHistory) {
      final blockedAt = DateTime.parse(history.blockedAt);
      final unblockedAt = history.unblockedAt != null 
          ? DateTime.parse(history.unblockedAt!) 
          : null;

      if (messageTime.isAfter(blockedAt)) {
        if (unblockedAt == null || messageTime.isBefore(unblockedAt)) {
          return false;
        }
      }
    }
    return true;
  }
}