// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_contact/chat_contact_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/tools/chat_time_formatter.dart';
import 'package:snap_local/common/utils/widgets/custom_alert_dialog.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/unseen_post_count_widget.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class ChatContactWidget extends StatelessWidget {
  const ChatContactWidget({
    super.key,
    required this.contact,
  });
  final ChatContactModel contact;

  bool get isOtherCommunication =>
      contact.communicationModel is OtherCommunicationModel;

  @override
  Widget build(BuildContext context) {
    final ConversationModel? lastMessage =
        contact.communicationModel.lastMessage;
    //Last message widget show conditions
    final showLastMessage = ((lastMessage != null &&
                //1. If the message is sent when the user is blocked and
                //the last message is sent by the current user
                lastMessage.messageSentWhenBlocked &&
                lastMessage.isCurrentUser)

            //OR
            ||

            //2. If the last message is not sent by the current user
            (lastMessage != null && !lastMessage.messageSentWhenBlocked))

        //AND
        &&
        //3. If the isCommunicationVisible in the communication user analytics is true for the current user
        //and the last message is sent by the current user
        (contact.communicationModel.communicationUsersAnalytics
            .firstWhere((element) => element.userId != contact.contactId)
            .showLastMessage);

    return BlocBuilder<ChatContactCubit, ChatContactState>(
      builder: (context, chatContactState) {
        return GestureDetector(
          onTap: chatContactState.chatDeleteLoading
              ? null
              : () {
                  GoRouter.of(context).pushNamed(
                    ChatScreen.routeName,
                    queryParameters: {"receiver_user_id": contact.contactId},
                    extra: isOtherCommunication
                        ? (contact.communicationModel
                                as OtherCommunicationModel)
                            .otherCommunicationPost
                        : null,
                  );
                },
          onLongPress: chatContactState.chatDeleteLoading
              ? null
              : () {
                  final chatContactCubit = context.read<ChatContactCubit>();
                  showCustomAlertDialog(context,
                      svgImagePath: SVGAssetsImages.chatFill,
                      title: tr(LocaleKeys.confirmDeletion),
                      description: tr(LocaleKeys
                          .areyousureyouwanttodeletethischatconversation),
                      action: BlocConsumer<ChatContactCubit, ChatContactState>(
                        bloc: chatContactCubit,
                        listener: (context, chatContactState) {
                          if (chatContactState.chatDeleteSuccess) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        builder: (context, chatContactState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ThemeElevatedButton(
                                showLoadingSpinner:
                                    chatContactState.chatDeleteLoading,
                                buttonName: tr(LocaleKeys.yes),
                                textFontSize: 12,
                                padding: EdgeInsets.zero,
                                width: 128,
                                height: 33,
                                onPressed: () {
                                  chatContactCubit.deleteChat(
                                    communicationModel:
                                        contact.communicationModel,
                                    isOtherCommunication: isOtherCommunication,
                                  );
                                },
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    ApplicationColours.themePinkColor,
                              ),
                              ThemeElevatedButton(
                                disableButton:
                                    chatContactState.chatDeleteLoading,
                                buttonName: tr(LocaleKeys.cancel),
                                textFontSize: 12,
                                padding: EdgeInsets.zero,
                                width: 128,
                                height: 33,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // Keep editing
                                },
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    ApplicationColours.themeBlueColor,
                              ),
                            ],
                          );
                        },
                      ));
                },
          child: AbsorbPointer(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: contact.contactImage.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: OctagonWidget(
                          shapeSize: 45,
                          child: contact.isBlockedByReceiver
                              ? const AssetImageCircleAvatar(
                                  radius: 60,
                                  imageurl: PNGAssetsImages.defaultAvatar,
                                )
                              : NetworkImageCircleAvatar(
                                  radius: 25,
                                  imageurl: contact.contactImage,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.contactName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (showLastMessage)
                            LastMessageWidget(
                              lastMessage: lastMessage,
                              isLastMessageDeleted:
                                  contact.isLastMessageDeleted,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Special name for other communication type
                          if (isOtherCommunication &&
                              (contact.subTitleDisplayName != null))
                            Text(
                              contact.subTitleDisplayName!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ApplicationColours.themePinkColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          // Last message time
                          if (lastMessage != null)
                            Text(
                              formatLastChatTime(lastMessage.createdTime),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color.fromRGBO(141, 135, 137, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          //Unseen message count
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: UnSeenCountWidget(
                              unSeenPostCount: contact.unreadMessageCount,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ThemeDivider(height: 2, thickness: 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LastMessageWidget extends StatelessWidget {
  final ConversationModel lastMessage;
  final bool isLastMessageDeleted;
  const LastMessageWidget({
    super.key,
    required this.lastMessage,
    required this.isLastMessageDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final isImageMessage = lastMessage.messageType == MessageType.image;
    final isPostMessage = lastMessage.messageType == MessageType.post;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Visibility(
            visible: isLastMessageDeleted || isImageMessage || isPostMessage,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                isLastMessageDeleted
                    ? Icons.block_flipped
                    : isImageMessage
                        ? FeatherIcons.camera
                        : FeatherIcons.instagram,
                size: 12,
                color: const Color.fromRGBO(141, 135, 137, 1),
              ),
            ),
          ),
          Flexible(
            child: Text(
              tr(
                isLastMessageDeleted
                    ? "Message deleted"
                    : lastMessage.message.isNotEmpty
                        ? lastMessage.message
                        : lastMessage.messageType.displayName,
              ),
              maxLines: lastMessage.messageType != MessageType.text ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color.fromRGBO(141, 135, 137, 1),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
