import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import '../models/local_chat_model.dart';

class LocalChatsWidget extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const LocalChatsWidget({
    Key? key,
    required this.chatId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<LocalChatsWidget> createState() => _LocalChatsWidgetState();
}

class _LocalChatsWidgetState extends State<LocalChatsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(FirebasePath.chats)
          .doc(widget.chatId)
          .collection(FirebasePath.messages)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data?.docs
                .map((doc) => LocalChatModel.fromFirestore(doc))
                .toList() ??
            [];

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageItem(message);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(LocalChatModel message) {
    final isMe = message.senderId == widget.currentUserId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (message.emojis.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildEmojiReactions(message),
                ],
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmojiReactions(LocalChatModel message) {
    return Wrap(
      spacing: 4,
      children: message.emojis.map((emoji) {
        final count = message.emojiCount[emoji] ?? 0;
        final senders = message.emojiSenders[emoji] ?? [];
        final hasReacted = senders.contains(widget.currentUserId);

        return GestureDetector(
          onTap: () {
            _handleEmojiTap(message, emoji, hasReacted);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasReacted ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleEmojiTap(
      LocalChatModel message, String emoji, bool hasReacted) async {
    final messageRef = _firestore
        .collection(FirebasePath.chats)
        .doc(widget.chatId)
        .collection(FirebasePath.messages)
        .doc(message.id);

    if (hasReacted) {
      // Remove reaction
      await messageRef.update({
        'emojiCount.$emoji': FieldValue.increment(-1),
        'emojiSenders.$emoji': FieldValue.arrayRemove([widget.currentUserId]),
      });
    } else {
      // Add reaction
      await messageRef.update({
        'emojiCount.$emoji': FieldValue.increment(1),
        'emojiSenders.$emoji': FieldValue.arrayUnion([widget.currentUserId]),
      });
    }
  }
} 