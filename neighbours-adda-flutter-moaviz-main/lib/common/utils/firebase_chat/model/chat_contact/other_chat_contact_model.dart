import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/business_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/job_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/page_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/sales_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/business_communication_post.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/job_communication_post.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/page_communication.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/sales_communication_post.dart';

abstract class OtherChatContactModel extends ChatContactModel {
  final OtherCommunicationModel otherCommunicationModel;
  final String currentUserId;
  OtherChatContactModel({
    required super.contactId,
    required super.contactTitle,
    required super.contactImage,
    required this.otherCommunicationModel,
    required this.currentUserId,
    required super.isBlockedByReceiver,
    required super.unreadMessageCount,
    required super.isLastMessageDeleted,
  }) : super(communicationModel: otherCommunicationModel);

  @override
  String get contactName => contactTitle;

  Future<OtherChatContactModel> fetchDataFromServer() async => this;

  //other chat contact model from the OtherCommunicationModel type
  factory OtherChatContactModel.create({
    required OtherCommunicationModel otherCommunicationModel,
    required String contactId,
    required String contactTitle,
    required String contactImage,
    required bool isBlockedByReceiver,
    required int unreadMessageCount,
    required bool isLastMessageDeleted,
    required String currentUserId,
  }) {
    switch (otherCommunicationModel) {
      case SalesPostCommunicationModel _:
        return SalesChatContactModel(
          contactId: contactId,
          contactTitle: contactTitle,
          contactImage: contactImage,
          currentUserId: currentUserId,
          isBlockedByReceiver: isBlockedByReceiver,
          unreadMessageCount: unreadMessageCount,
          isLastMessageDeleted: isLastMessageDeleted,
          otherCommunicationModel: otherCommunicationModel,
        );
      case JobCommunicationModel _:
        return JobChatContactModel(
          contactId: contactId,
          contactTitle: contactTitle,
          contactImage: contactImage,
          currentUserId: currentUserId,
          isBlockedByReceiver: isBlockedByReceiver,
          unreadMessageCount: unreadMessageCount,
          isLastMessageDeleted: isLastMessageDeleted,
          otherCommunicationModel: otherCommunicationModel,
        );
      case BusinessPostCommunicationModel _:
        return BusinessChatContactModel(
          contactId: contactId,
          currentUserId: currentUserId,
          contactTitle: contactTitle,
          contactImage: contactImage,
          isBlockedByReceiver: isBlockedByReceiver,
          unreadMessageCount: unreadMessageCount,
          isLastMessageDeleted: isLastMessageDeleted,
          otherCommunicationModel: otherCommunicationModel,
        );
      case PageCommunicationModel _:
        return PageChatContactModel(
          contactId: contactId,
          contactTitle: contactTitle,
          contactImage: contactImage,
          currentUserId: currentUserId,
          isBlockedByReceiver: isBlockedByReceiver,
          unreadMessageCount: unreadMessageCount,
          isLastMessageDeleted: isLastMessageDeleted,
          otherCommunicationModel: otherCommunicationModel,
        );
      default:
        throw ArgumentError(
            "Unknown Other Communication type: $otherCommunicationModel");
    }
  }

  //copy with
  OtherChatContactModel copyWith({
    String? contactId,
    String? contactTitle,
    String? contactImage,
    OtherCommunicationModel? otherCommunicationModel,
    String? currentUserId,
    bool? isBlockedByReceiver,
    int? unreadMessageCount,
    bool? isLastMessageDeleted,
  }) {
    return OtherChatContactModel.create(
      contactId: contactId ?? this.contactId,
      contactTitle: contactTitle ?? this.contactTitle,
      contactImage: contactImage ?? this.contactImage,
      otherCommunicationModel:
          otherCommunicationModel ?? this.otherCommunicationModel,
      currentUserId: currentUserId ?? this.currentUserId,
      isBlockedByReceiver: isBlockedByReceiver ?? this.isBlockedByReceiver,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
    );
  }
}
