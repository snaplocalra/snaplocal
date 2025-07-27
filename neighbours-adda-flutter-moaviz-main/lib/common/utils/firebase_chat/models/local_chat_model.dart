import 'package:cloud_firestore/cloud_firestore.dart';

class LocalChatModel {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;
  final List<String> emojis;
  final Map<String, int> emojiCount;
  final Map<String, List<String>> emojiSenders;

  LocalChatModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.emojis,
    required this.emojiCount,
    required this.emojiSenders,
  });

  factory LocalChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocalChatModel(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      emojis: List<String>.from(data['emojis'] ?? []),
      emojiCount: Map<String, int>.from(data['emojiCount'] ?? {}),
      emojiSenders: Map<String, List<String>>.from(data['emojiSenders'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
      'emojis': emojis,
      'emojiCount': emojiCount,
      'emojiSenders': emojiSenders,
    };
  }
} 