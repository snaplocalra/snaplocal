import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_status.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_bubble/bubble_chat_image.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_bubble/bubble_chat_pdf.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_bubble/bubble_chat_text.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_bubble/social_post_chat_bubble.dart';
import 'package:snap_local/utility/download/download_cubit.dart';
import 'package:snap_local/utility/media_player/video/video_player_screen.dart';

class ChatMessageWidget extends StatelessWidget {
  final ConversationModel conversationModel;
  final bool isCurrentUser;
  const ChatMessageWidget({
    super.key,
    required this.conversationModel,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    bool seen = isCurrentUser &&
        conversationModel.messageStatusInfo.status == MessageStatus.read;

    bool sent = isCurrentUser &&
        conversationModel.messageStatusInfo.status == MessageStatus.sent;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: Colors.transparent,
      child: conversationModel.messageType == MessageType.image ||
              conversationModel.messageType == MessageType.video
          ? BubbleChatImage(
              key: Key(conversationModel.conversationId!),
              text: conversationModel.message,
              timeStampText:
                  DateFormat("h:mm a").format(conversationModel.createdTime),
              imageUrl: conversationModel.messageType == MessageType.video
                  ? conversationModel.conversationFileModel!.fileThumbnailUrl!
                  : conversationModel.conversationFileModel!.fileUrl,
              isSender: isCurrentUser,
              color: isCurrentUser
                  ? const Color.fromRGBO(0, 92, 75, 1)
                  : const Color.fromRGBO(32, 44, 51, 1),
              tail: true,
              textStyle: const TextStyle(color: Colors.white),
              isVideoType: conversationModel.messageType == MessageType.video,
              videoUrl: conversationModel.conversationFileModel!.fileUrl,
              onPlayButtonTap: () {
                GoRouter.of(context)
                    .pushNamed(VideoPlayerScreen.routeName, queryParameters: {
                  'video_url': conversationModel.conversationFileModel!.fileUrl
                });
              },
              sent: sent,
              seen: seen,
            )
          : conversationModel.messageType == MessageType.audio
              ?
              //TODO: Need to implement AudioPlayerWidget
              const SizedBox.shrink()
              //  BubbleChatAudio(
              //     key: Key(conversationModel.conversationId!),
              //     audioUrl: conversationModel.conversationFileModel!.fileUrl,
              //     text: conversationModel.message,
              //     isSender: isCurrentUser,
              //     color: isCurrentUser
              //         ? const Color.fromRGBO(0, 92, 75, 1)
              //         : const Color.fromRGBO(32, 44, 51, 1),
              //     timeStampText: DateFormat("h:mm a")
              //         .format(conversationModel.createdTime),
              //     tail: true,
              //     textStyle: const TextStyle(color: Colors.white),
              //     sent: sent,
              //     seen: seen,
              //   )
              : conversationModel.messageType == MessageType.pdf
                  ? BubbleChatPdf(
                      key: Key(conversationModel.conversationId!),
                      text: conversationModel.message,
                      timeStampText: DateFormat("h:mm a")
                          .format(conversationModel.createdTime),
                      isSender: isCurrentUser,
                      color: isCurrentUser
                          ? const Color.fromRGBO(0, 92, 75, 1)
                          : const Color.fromRGBO(32, 44, 51, 1),
                      tail: true,
                      textStyle: const TextStyle(color: Colors.white),
                      pdfName:
                          conversationModel.conversationFileModel!.fileName,
                      onDownloadClicked: () {
                        context.read<DownloadCubit>().downloadFile(
                            url: conversationModel
                                .conversationFileModel!.fileUrl,
                            fileName: conversationModel
                                .conversationFileModel!.fileName);
                      },
                      sent: sent,
                      seen: seen,
                    )
                  : (conversationModel.socialPostModel != null &&
                          conversationModel.messageType == MessageType.post)
                      ? SocialPostChatBubble(
                          key: Key(conversationModel.conversationId!),
                          socialPostModel: conversationModel.socialPostModel!,
                          timeStampText: DateFormat("h:mm a")
                              .format(conversationModel.createdTime),
                          isSender: isCurrentUser,
                          color: isCurrentUser
                              ? const Color.fromRGBO(0, 92, 75, 1)
                              : Colors.grey.shade800,
                          tail: true,
                          textStyle: const TextStyle(color: Colors.white),
                          sent: sent,
                          seen: seen,
                        )
                      : BubbleChatText(
                          key: Key(conversationModel.conversationId!),
                          text: conversationModel.message,
                          timeStampText: DateFormat("h:mm a")
                              .format(conversationModel.createdTime),
                          isSender: isCurrentUser,
                          color: isCurrentUser
                              ? const Color.fromRGBO(0, 92, 75, 1)
                              : const Color.fromRGBO(32, 44, 51, 1),
                          tail: true,
                          textStyle: const TextStyle(color: Colors.white),
                          sent: sent,
                          seen: seen,
                        ),
    );
  }
}
