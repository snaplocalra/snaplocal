import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';

//neighbours contact model
class NeighboursChatContact extends ChatContactModel {
  NeighboursChatContact({
    required super.communicationModel,
    required super.contactId,
    required super.contactTitle,
    required super.contactImage,
    required super.isBlockedByReceiver,
    required super.unreadMessageCount,
    required super.isLastMessageDeleted,
  });

  @override
  String get contactName => contactTitle;
}
