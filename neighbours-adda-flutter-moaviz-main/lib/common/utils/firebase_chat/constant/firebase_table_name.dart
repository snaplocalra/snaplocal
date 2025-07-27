import 'package:flutter/foundation.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';

class FirebasePath {
  static const String users = isProduction ? 'users' : 'users_dev';
  static const String userList = isProduction ? 'user_list' : 'user_list_dev';
  static const String conversation = !isProduction ? 'conversation_dev' : 'conversation';
  static const String userCommunication = !isProduction ? 'user_communication_dev' : 'user_communication';
  static const String otherCommunication = !isProduction ? 'other_communication_dev' : 'other_communication';
  static const String messageRequestStatus = !isProduction ? 'message_request_status_dev' : 'message_request_status';
  static const String chats = isProduction? 'chats' : 'chats_dev';
  static const String messages = isProduction? 'messages' : 'messages_dev';
  static const String localChats = isProduction? 'local_chats' : 'local_chats_dev';
  static const String localChatsActiveUsers = isProduction? 'local_chats_active_users' : 'local_chats_dev_active_users';
  static const String blockedUsersHistory = isProduction? 'blocked_users_history' : 'blocked_users_dev_history';
}

class FirebaseField {
  static const String isLastMessageDeleted = 'is_last_message_deleted';
  static const String lastMessage = 'last_message';
  static const String documents =  !isProduction ? 'dev_documents' : 'documents';
  static const String createdTime = 'created_time';
  static const String message = 'message';
  // static const String isBlock = 'is_block';
  static const String users = 'users';
  static const String messageStatusInfo = 'message_status_info';
  static const String communicationUsersAnalytics =
      'communication_users_analytics';
  static const String otherCommunicationDetails = "other_communication_details";
}
