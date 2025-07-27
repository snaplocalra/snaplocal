// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';

class ProfileConnectionDetailsModel {
  final String? connectionId;
  final bool isConnectionRequestSender;
  final ConnectionStatus connectionStatus;

  ProfileConnectionDetailsModel({
    this.connectionId,
    required this.isConnectionRequestSender,
    required this.connectionStatus,
  });

  factory ProfileConnectionDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProfileConnectionDetailsModel(
      connectionId: map['connection_id'],
      isConnectionRequestSender: (map['is_connection_request_sender'] ?? false) as bool,
      connectionStatus: ConnectionStatus.fromString(map['connection_status']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'connection_id': connectionId,
      'is_connection_request_sender': isConnectionRequestSender,
      'connection_status': connectionStatus.jsonValue,
    };
  }
}
