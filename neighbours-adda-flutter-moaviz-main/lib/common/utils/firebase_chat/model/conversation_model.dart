// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_status.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';

class ConversationFileModel {
  //Files handling variables
  final String fileUrl;
  final String fileName;
  final String? fileThumbnailUrl;

  ConversationFileModel({
    required this.fileUrl,
    required this.fileName,
    this.fileThumbnailUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'file_url': fileUrl,
      'file_name': fileName,
      'file_thumbnail_url': fileThumbnailUrl,
    };
  }

  factory ConversationFileModel.fromMap(Map<String, dynamic> map) {
    return ConversationFileModel(
      fileUrl: map['file_url'],
      fileName: map['file_name'],
      fileThumbnailUrl: map['file_thumbnail_url'],
    );
  }
}

class ConversationModel {
  final String? conversationId;
  final String message;
  final SocialPostModel? socialPostModel;
  final DateTime createdTime;
  final MessageType messageType;
  final String senderId;
  final String receiverId;
  final List<String> deletedFor;

  ///This variable will use to avoid the visibilty for the user who blocked the sender,
  final bool messageSentWhenBlocked;

  //This will use after data fetching from the firestore
  //to check the message is sent by the current user or not
  final bool isCurrentUser;

  //Files container
  final ConversationFileModel? conversationFileModel;

  //Message status
  MessageStatusInfo messageStatusInfo;

  ConversationModel({
    this.conversationId,
    required this.message,
    required this.createdTime,
    required this.messageType,
    required this.socialPostModel,
    required this.senderId,
    required this.receiverId,
    this.deletedFor = const [],
    this.messageSentWhenBlocked = false,
    this.conversationFileModel,
    this.isCurrentUser = false,
    required this.messageStatusInfo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conversation_id': conversationId,
      'message': message,
      'created_time': createdTime.millisecondsSinceEpoch,
      'message_type': messageType.param,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_sent_when_blocked': messageSentWhenBlocked,
      'conversation_file_model': conversationFileModel?.toMap(),
      'social_post_model': socialPostModel?.toMap(),
      'deleted_for': deletedFor,
      'message_status_info': messageStatusInfo.toMap(),
    };
  }

  factory ConversationModel.fromMap(
    Map<String, dynamic> map, {
    ///If null then the message is not assign false by default on the isSendByCurrentUser,
    ///If not null then check that the message is sent by the current user or not
    String? currentUserId,
  }) {
    return ConversationModel(
      conversationId: map['conversation_id'],
      message: (map['message'] ?? '') as String,
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['created_time']),
      messageType: MessageType.setMessageType(map['message_type']),
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      messageSentWhenBlocked: map['message_sent_when_blocked'] as bool,
      conversationFileModel: map['conversation_file_model'] == null
          ? null
          : ConversationFileModel.fromMap(map['conversation_file_model']),
      socialPostModel: map['social_post_model'] == null
          ? null
          : SocialPostModel.getModelByType(map['social_post_model']),
      deletedFor: List<String>.from(map['deleted_for']),
      isCurrentUser: map['sender_id'] == currentUserId,
      messageStatusInfo: MessageStatusInfo.fromMap(map['message_status_info']),
    );
  }

  ConversationModel copyWith({
    String? conversationId,
    String? message,
    SocialPostModel? socialPostModel,
    DateTime? createdTime,
    MessageType? messageType,
    String? senderId,
    String? receiverId,
    List<String>? deletedFor,
    bool? messageSentWhenBlocked,
    ConversationFileModel? conversationFileModel,
    MessageStatusInfo? messageStatusInfo,
    bool? isCurrentUser,
  }) {
    return ConversationModel(
      conversationId: conversationId ?? this.conversationId,
      message: message ?? this.message,
      socialPostModel: socialPostModel ?? this.socialPostModel,
      createdTime: createdTime ?? this.createdTime,
      messageType: messageType ?? this.messageType,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      deletedFor: deletedFor ?? this.deletedFor,
      messageSentWhenBlocked:
          messageSentWhenBlocked ?? this.messageSentWhenBlocked,
      conversationFileModel:
          conversationFileModel ?? this.conversationFileModel,
      messageStatusInfo: messageStatusInfo ?? this.messageStatusInfo,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
