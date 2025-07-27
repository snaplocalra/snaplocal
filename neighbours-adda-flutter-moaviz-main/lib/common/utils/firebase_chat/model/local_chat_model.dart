import 'package:cloud_firestore/cloud_firestore.dart';

class LocalChatModel {
  final String? id; // Document ID from Firestore
  final String senderId;
  final String senderName;
  final String senderProfilePathUrl;
  final String message;
  final Timestamp timestamp;
  final DateTime sentDateTime;
  final List<String> emojis;
  final Map<String, int> emojiCount;
  final Map<String, List<String>> emojiSenders;
  final String? replyParentMessage;
  final String? replyParentUsername;
  final String? replyParentUserId;
  // Add location fields
  final String? geoHash;
  final double? latitude;
  final double? longitude;

  LocalChatModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.senderProfilePathUrl,
    required this.message,
    required this.timestamp,
    required this.sentDateTime,
    required this.emojis,
    required this.emojiCount,
    required this.emojiSenders,
    this.replyParentMessage,
    this.replyParentUsername,
    this.replyParentUserId,
    this.geoHash,
    this.latitude,
    this.longitude,
  });

  factory LocalChatModel.fromJson(Map<String, dynamic> json) {
    // Handle the timestamp conversion safely
    Timestamp timestamp;
    try {
      if (json['timestamp'] is Timestamp) {
        timestamp = json['timestamp'] as Timestamp;
      } else if (json['timestamp'] is Map) {
        // Handle Firestore Timestamp object format
        final timestampMap = json['timestamp'] as Map;
        timestamp = Timestamp(
          timestampMap['_seconds'] ?? 0,
          timestampMap['_nanoseconds'] ?? 0,
        );
      } else {
        timestamp = Timestamp.now();
      }
    } catch (e) {
      timestamp = Timestamp.now();
    }

    // Handle sent_date_time conversion
    DateTime sentDateTime;
    try {
      if (json['sent_date_time'] is Timestamp) {
        sentDateTime = (json['sent_date_time'] as Timestamp).toDate();
      } else if (json['sent_date_time'] is Map) {
        // Handle Firestore Timestamp object format
        final timestampMap = json['sent_date_time'] as Map;
        final ts = Timestamp(
          timestampMap['_seconds'] ?? 0,
          timestampMap['_nanoseconds'] ?? 0,
        );
        sentDateTime = ts.toDate();
      } else {
        sentDateTime = timestamp.toDate();
      }
    } catch (e) {
      sentDateTime = timestamp.toDate();
    }

    // Handle emoji count conversion
    Map<String, int> emojiCount = {};
    try {
      if (json['emoji_count'] != null) {
        final rawCount = json['emoji_count'] as Map;
        emojiCount = rawCount.map(
            (key, value) => MapEntry(key.toString(), (value as num).toInt()));
      }
    } catch (e) {
      emojiCount = {};
    }

    // Handle emoji senders conversion
    Map<String, List<String>> emojiSenders = {};
    try {
      if (json['emoji_senders'] != null) {
        final rawSenders = json['emoji_senders'] as Map;
        emojiSenders = rawSenders.map(
            (key, value) => MapEntry(key.toString(), List<String>.from(value)));
      }
    } catch (e) {
      emojiSenders = {};
    }

    return LocalChatModel(
      id: json['id']?.toString(),
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ?? '',
      senderProfilePathUrl: json['sender_profile_path_url']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      timestamp: timestamp,
      sentDateTime: sentDateTime,
      emojis: List<String>.from(json['emojis'] ?? []),
      emojiCount: emojiCount,
      emojiSenders: emojiSenders,
      replyParentMessage: json['reply_parent_message']?.toString(),
      replyParentUsername: json['reply_parent_username']?.toString(),
      replyParentUserId: json['reply_parent_user_id']?.toString(),
      // Add location fields
      geoHash: json['geo_hash']?.toString(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_profile_path_url': senderProfilePathUrl,
      'message': message,
      'timestamp': timestamp,
      'sent_date_time': Timestamp.fromDate(sentDateTime),
      'emojis': emojis,
      'emoji_count': emojiCount,
      'emoji_senders': emojiSenders,
      'reply_parent_message': replyParentMessage,
      'reply_parent_username': replyParentUsername,
      'reply_parent_user_id': replyParentUserId,
      // Add location fields
      'geo_hash': geoHash,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
