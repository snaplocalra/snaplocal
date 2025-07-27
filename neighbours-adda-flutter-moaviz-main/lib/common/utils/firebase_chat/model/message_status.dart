class MessageStatusInfo {
  final MessageStatus status;
  final DateTime? time;

  MessageStatusInfo({
    required this.status,
    required this.time,
  });

  MessageStatusInfo copyWith({
    MessageStatus? status,
    DateTime? time,
  }) {
    return MessageStatusInfo(
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status.name,
      'time': time?.millisecondsSinceEpoch,
    };
  }

  factory MessageStatusInfo.fromMap(Map<String, dynamic> map) {
    return MessageStatusInfo(
      status: MessageStatus.fromString(map['status']),
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'])
          : null,
    );
  }
}

enum MessageStatus {
  sent,
  delivered,
  read;

//from String to MessageStatus
  factory MessageStatus.fromString(String messageStatus) {
    switch (messageStatus) {
      case "sent":
        return MessageStatus.sent;
      case "delivered":
        return MessageStatus.delivered;
      case "read":
        return MessageStatus.read;
      default:
        throw Exception("Invalid message status");
    }
  }
}
