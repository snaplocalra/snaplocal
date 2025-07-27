// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';

class GroupConnectionDetailsModel {
  final String? connectionId;
  final bool isConnectionRequestSender;
  final ConnectionStatus connectionStatus;

  GroupConnectionDetailsModel({
    this.connectionId,
    required this.isConnectionRequestSender,
    required this.connectionStatus,
  });

  factory GroupConnectionDetailsModel.fromMap(Map<String, dynamic> map) {
    return GroupConnectionDetailsModel(
      connectionId:
          map['connection_id'] != null ? map['connection_id'] as String : null,
      isConnectionRequestSender:
          (map['is_connection_request_sender'] ?? false) as bool,
      connectionStatus: ConnectionStatus.fromString(map['connection_status']),
    );
  }
}
