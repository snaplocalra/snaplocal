class ConnectionConnectResponse {
  final String status;
  final String message;

  ConnectionConnectResponse({
    required this.status,
    required this.message,
  });

  factory ConnectionConnectResponse.fromMap(Map<String, dynamic> map) {
    return ConnectionConnectResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
    );
  }
} 