import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/repository/page_details_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/other_chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/page_communication.dart';

//page contact model
class PageChatContactModel extends OtherChatContactModel {
  PageCommunicationImpl get pageCommunicationImpl =>
      (otherCommunicationModel as PageCommunicationModel).otherCommunicationPost
          as PageCommunicationImpl;

  PageChatContactModel({
    required super.currentUserId,
    required super.otherCommunicationModel,
    required super.contactId,
    required super.contactTitle,
    required super.contactImage,
    required super.isBlockedByReceiver,
    required super.unreadMessageCount,
    required super.isLastMessageDeleted,
  });

  bool get isPageAdmin => pageCommunicationImpl.pageAdminId == currentUserId;

  @override
  String get contactName => isPageAdmin
      ? contactTitle
      : otherCommunicationModel.otherCommunicationPost.displayName;

  @override
  String? get subTitleDisplayName => isPageAdmin
      ? otherCommunicationModel.otherCommunicationPost.displayName
      : null;

  @override
  Future<OtherChatContactModel> fetchDataFromServer() async {
    try {
      return await PageDetailsRepository()
          .fetchPageDetails(
              pageId: otherCommunicationModel.otherCommunicationPost.id)
          .then((value) {
        return isPageAdmin
            ? this
            : copyWith(
                contactTitle: value.pageProfileDetailsModel.name,
                contactImage: value.pageProfileDetailsModel.coverImage,
                otherCommunicationModel: otherCommunicationModel.copyWith(
                  otherCommunicationPost: pageCommunicationImpl.copyWith(
                    displayName: value.pageProfileDetailsModel.name,
                  ),
                ),
              );
      });
    } catch (e) {
      return this;
    }
  }
}
