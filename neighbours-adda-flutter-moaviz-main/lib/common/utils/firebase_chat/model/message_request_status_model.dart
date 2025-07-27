class MessageRequestStatusModel {
  final String communicationId;
  final MessageRequestStatus status;
  final String requestSender;
  final String requestReceiver;

  MessageRequestStatusModel({
    required this.communicationId,
    required this.status,
    required this.requestSender,
    required this.requestReceiver,
  });

  Map<String, dynamic> toMap() {
    return {
      'communicationId': communicationId,
      'status': status.name,
      'requestSender': requestSender,
      'requestReceiver': requestReceiver,
    };
  }

  factory MessageRequestStatusModel.fromMap(Map<String, dynamic> map) {
    return MessageRequestStatusModel(
      communicationId: map['communicationId'],
      status: MessageRequestStatus.fromString(map['status']),
      requestSender: map['requestSender'],
      requestReceiver: map['requestReceiver'],
    );
  }
}

enum MessageRequestStatus {
  pending,
  accepted,
  rejected;

  factory MessageRequestStatus.fromString(String status) {
    switch (status) {
      case 'pending':
        return pending;
      case 'accepted':
        return accepted;
      case 'rejected':
        return rejected;
      default:
        throw Exception('Invalid status');
    }
  }
}
