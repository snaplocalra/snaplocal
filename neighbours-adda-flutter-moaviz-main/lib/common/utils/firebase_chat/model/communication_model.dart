import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';

import '../../../../utility/constant/errors.dart';

class CommunicationModel {
  final String communicationId;
  final bool isLastMessageDeleted;
  final ConversationModel? lastMessage;
  final List<String> users;
  final List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics;

  CommunicationModel({
    required this.communicationId,
    required this.users,
    this.isLastMessageDeleted = false,
    this.lastMessage,
    required this.communicationUsersAnalytics,
  });

  //Check all the users are online or not
  bool get isAllUsersOnline {
    return communicationUsersAnalytics.every((element) => element.isOnline);
  }


  factory CommunicationModel.fromMap(
      Map<String, dynamic> map, {
        String? currentUserId,
      }) {
    if (isDebug) {
      try {
        return _buildCommunication(map, currentUserId: currentUserId);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildCommunication(map, currentUserId: currentUserId);
    }
  }

  static CommunicationModel _buildCommunication(
    Map<String, dynamic> map, {
    String? currentUserId,
  }) {
    return CommunicationModel(
      communicationId: map['communication_id'],
      users: List<String>.from(map['users']),
      isLastMessageDeleted: map['is_last_message_deleted'],
      lastMessage: map['last_message'] == null
          ? null
          : ConversationModel.fromMap(
              map['last_message'],
              currentUserId: currentUserId,
            ),
      communicationUsersAnalytics: map['communication_users_analytics'] == null
          ? []
          : List<CommunicationUsersAnalyticsModel>.from(
              map['communication_users_analytics']
                  .map((e) => CommunicationUsersAnalyticsModel.fromMap(e)),
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communication_id': communicationId,
      'last_message': lastMessage?.toMap(),
      'is_last_message_deleted': isLastMessageDeleted,
      'users': users.map((e) => e).toList(),
      'communication_users_analytics':
          communicationUsersAnalytics.map((e) => e.toMap()).toList(),
    };
  }
}

class CommunicationUsersAnalyticsModel {
  final String userId;
  int unseenMessageCount;
  bool isOnline;
  DateTime? lastChatDeleteTime;
  bool isCommunicationVisilbe;
  bool showLastMessage;

  CommunicationUsersAnalyticsModel({
    required this.userId,
    required this.unseenMessageCount,
    this.isOnline = false,
    this.lastChatDeleteTime,
    this.isCommunicationVisilbe = true,
    this.showLastMessage = true,
  });

  factory CommunicationUsersAnalyticsModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildAnalytics(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildAnalytics(map);
    }
  }

  static CommunicationUsersAnalyticsModel _buildAnalytics(Map<String, dynamic> map) {
    return CommunicationUsersAnalyticsModel(
      userId: map['user_id'],
      unseenMessageCount: map['unseen_message_count'],
      isOnline: map['is_online'] ?? false,
      showLastMessage: map['show_last_message'] ?? true,
      lastChatDeleteTime: map['last_chat_delete_time'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['last_chat_delete_time']),
      isCommunicationVisilbe: map['is_communication_visilbe'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'unseen_message_count': unseenMessageCount,
      'is_online': isOnline,
      'last_chat_delete_time': lastChatDeleteTime?.millisecondsSinceEpoch,
      'is_communication_visilbe': isCommunicationVisilbe,
      'show_last_message': showLastMessage,
    };
  }

  //copyWith method
  CommunicationUsersAnalyticsModel copyWith({
    String? userId,
    int? unseenMessageCount,
    bool? isOnline,
    DateTime? lastChatDeleteTime,
    bool? isCommunicationVisilbe,
    bool? showLastMessage,
  }) {
    return CommunicationUsersAnalyticsModel(
      userId: userId ?? this.userId,
      unseenMessageCount: unseenMessageCount ?? this.unseenMessageCount,
      isOnline: isOnline ?? this.isOnline,
      lastChatDeleteTime: lastChatDeleteTime ?? this.lastChatDeleteTime,
      isCommunicationVisilbe:
          isCommunicationVisilbe ?? this.isCommunicationVisilbe,
      showLastMessage: showLastMessage ?? this.showLastMessage,
    );
  }
}
