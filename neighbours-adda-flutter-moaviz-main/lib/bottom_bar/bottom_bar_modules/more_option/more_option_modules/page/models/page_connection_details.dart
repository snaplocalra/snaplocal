import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';

class ConnectionDetailsModel {
  final String? connectionId;
  final bool isConnectionRequestSender;
  final ConnectionStatus connectionStatus;

  ConnectionDetailsModel({
    this.connectionId,
    required this.isConnectionRequestSender,
    required this.connectionStatus,
  });

  factory ConnectionDetailsModel.fromMap(Map<String, dynamic> map) {
    return ConnectionDetailsModel(
      connectionId:
          map['connection_id'] != null ? map['connection_id'] as String : null,
      isConnectionRequestSender:
          (map['is_connection_request_sender'] ?? false) as bool,
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
