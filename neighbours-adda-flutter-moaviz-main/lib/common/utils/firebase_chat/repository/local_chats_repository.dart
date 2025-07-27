import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_model.dart';

class LocalChatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final String _collectionPath = 'local_chats_dev';

  // Get stream of local chat messages
  Stream<List<LocalChatModel>> getLocalChats(String geoHash) {
    return _firestore
        .collection(FirebasePath.localChats)
        .where("geo_hash",isEqualTo: geoHash)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return LocalChatModel.fromJson(data);
      }).toList();
    });
  }

  // Send a new local chat message
  Future<DocumentReference> sendLocalChatMessage(LocalChatModel chatMessage) async {
    try {
      print(chatMessage.toJson());
      final docRef = await _firestore.collection(FirebasePath.localChats).add(chatMessage.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to send local chat message: $e');
    }
  }

  // Update emoji reactions
  Future<void> updateEmojiReaction(
      String messageId, String emoji, String userId) async {
    try {
      print('Updating emoji reaction - Message: $messageId, Emoji: $emoji, User: $userId');
      final docRef = _firestore.collection(FirebasePath.localChats).doc(messageId);
      
      await _firestore.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          
          // Safely convert the data to the correct types
          final currentEmojis = (data['emojis'] as List<dynamic>?)?.cast<String>() ?? [];
          final currentEmojiCount = Map<String, int>.from(
            (data['emoji_count'] as Map<dynamic, dynamic>?)?.map(
              (key, value) => MapEntry(key.toString(), (value as num).toInt())
            ) ?? {}
          );
          final currentEmojiSenders = Map<String, List<String>>.from(
            (data['emoji_senders'] as Map<dynamic, dynamic>?)?.map(
              (key, value) => MapEntry(
                key.toString(),
                (value as List<dynamic>).cast<String>()
              )
            ) ?? {}
          );

          // First, remove any existing reaction from this user
          String? previousEmoji;
          for (final emojiKey in currentEmojiSenders.keys) {
            if (currentEmojiSenders[emojiKey]?.contains(userId) ?? false) {
              previousEmoji = emojiKey;
              break;
            }
          }

          if (previousEmoji != null) {
            // Remove previous reaction
            currentEmojiCount[previousEmoji] = (currentEmojiCount[previousEmoji] ?? 1) - 1;
            if (currentEmojiCount[previousEmoji] == 0) {
              currentEmojis.remove(previousEmoji);
              currentEmojiCount.remove(previousEmoji);
              currentEmojiSenders.remove(previousEmoji);
              print('Removed previous emoji completely as count reached 0');
            } else {
              currentEmojiSenders[previousEmoji] = currentEmojiSenders[previousEmoji]!
                  .where((id) => id != userId)
                  .toList();
              print('Removed previous user reaction, new count: ${currentEmojiCount[previousEmoji]}');
            }
          }

          // Now add the new reaction
          if (!currentEmojis.contains(emoji)) {
            currentEmojis.add(emoji);
            print('Added new emoji to list');
          }
          currentEmojiCount[emoji] = (currentEmojiCount[emoji] ?? 0) + 1;
          currentEmojiSenders[emoji] = [...(currentEmojiSenders[emoji] ?? []), userId];
          print('Added user reaction, new count: ${currentEmojiCount[emoji]}');

          print('Updating document with new values');
          // Update the document with all changes
          transaction.update(docRef, {
            'emojis': currentEmojis,
            'emoji_count': currentEmojiCount,
            'emoji_senders': currentEmojiSenders,
          });
        } else {
          print('Document not found: $messageId');
        }
      });
      print('Successfully updated emoji reaction');
    } catch (e) {
      print('Failed to update emoji reaction: $e');
      throw Exception('Failed to update emoji reaction: $e');
    }
  }

} 