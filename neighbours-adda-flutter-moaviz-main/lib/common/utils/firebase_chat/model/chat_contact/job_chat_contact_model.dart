import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/other_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';

//job contact model
class JobChatContactModel extends OtherChatContactModel {
  JobChatContactModel({
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

  //copy with method
  @override
  JobChatContactModel copyWith({
    String? contactId,
    String? contactTitle,
    String? contactImage,
    bool? isBlockedByReceiver,
    int? unreadMessageCount,
    bool? isLastMessageDeleted,
    OtherCommunicationModel? otherCommunicationModel,
    String? currentUserId,
  }) {
    return JobChatContactModel(
      contactId: contactId ?? this.contactId,
      contactTitle: contactTitle ?? this.contactTitle,
      contactImage: contactImage ?? this.contactImage,
      isBlockedByReceiver: isBlockedByReceiver ?? this.isBlockedByReceiver,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
      otherCommunicationModel:
          otherCommunicationModel ?? this.otherCommunicationModel,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}
