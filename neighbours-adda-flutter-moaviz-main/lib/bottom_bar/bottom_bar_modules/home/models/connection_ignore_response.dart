class ConnectionIgnoreResponse {
  final String status;
  final String message;

  ConnectionIgnoreResponse({
    required this.status,
    required this.message,
  });

  factory ConnectionIgnoreResponse.fromMap(Map<String, dynamic> map) {
    return ConnectionIgnoreResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
    );
  }
} 