import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';

abstract class ChatContactModel {
  final String contactId;
  final String contactTitle;
  final String contactImage;
  final int unreadMessageCount;
  final CommunicationModel communicationModel;
  final bool isBlockedByReceiver;
  final bool isLastMessageDeleted;

  ChatContactModel({
    required this.contactId,
    required this.contactTitle,
    required this.contactImage,
    required this.unreadMessageCount,
    required this.communicationModel,
    required this.isBlockedByReceiver,
    required this.isLastMessageDeleted,
  });

  String get contactName => contactTitle;

  String? get subTitleDisplayName => null;
}
