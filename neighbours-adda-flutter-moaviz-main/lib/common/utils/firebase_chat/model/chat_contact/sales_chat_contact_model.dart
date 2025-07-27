import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/other_chat_contact_model.dart';

//sales contact model
class SalesChatContactModel extends OtherChatContactModel {
  SalesChatContactModel({
    required super.currentUserId,
    required super.otherCommunicationModel,
    required super.contactId,
    required super.contactTitle,
    required super.contactImage,
    required super.isBlockedByReceiver,
    required super.unreadMessageCount,
    required super.isLastMessageDeleted,
  });

  @override
  String? get subTitleDisplayName =>
      otherCommunicationModel.otherCommunicationPost.displayName;
}
