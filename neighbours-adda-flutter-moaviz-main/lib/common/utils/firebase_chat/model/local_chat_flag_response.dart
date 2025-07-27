class LocalChatFlagResponse {
  final String status;
  final String message;
  final LocalChatFlagData data;

  LocalChatFlagResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalChatFlagResponse.fromJson(Map<String, dynamic> json) {
    return LocalChatFlagResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: LocalChatFlagData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class LocalChatFlagData {
  final bool access;
  final String count;
  final String message;
  

  LocalChatFlagData({
    required this.access,
    required this.count,
    required this.message,
  });

  factory LocalChatFlagData.fromJson(Map<String, dynamic> json) {
    return LocalChatFlagData(
      access: json['access'] as bool,
      count: json['count'].toString(),
      message: json['message'].toString(),
    // Added with null safety
    );
  }
}