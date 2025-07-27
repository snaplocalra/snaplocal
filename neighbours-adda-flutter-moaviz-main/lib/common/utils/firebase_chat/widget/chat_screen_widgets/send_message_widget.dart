import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_attachment_dialog.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_camera_pop_up_button.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';

class SendMessageWidget extends StatefulWidget {
  final String? hint;

  ///If true, then the send button will visible even with empty text
  final bool alwaysEnableSendButton;
  final bool closeKeyboardAfterMessageSend;
  final bool disableSend;

  final void Function(String message) onTextMessageSend;
  final void Function(String message, File file, MessageType messageType)?
      onMessageWithFileSend;

  final TextEditingController? textEditingController;

  const SendMessageWidget({
    super.key,
    required this.onTextMessageSend,
    this.onMessageWithFileSend,
    this.textEditingController,
    this.alwaysEnableSendButton = false,
    this.closeKeyboardAfterMessageSend = false,
    this.disableSend = false,
    this.hint,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController != null) {
      messageController = widget.textEditingController!;
    } else {
      messageController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) {
      messageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      //This minLines and maxLines will make the textfield multiline
                      //as per the content grows
                      minLines: 1,
                      maxLines: 6,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          TextFieldInputLength.chatTextMaxLength,
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: widget.hint ?? "Type a message",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        border: InputBorder.none, // Remove bottom underline
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (widget.onMessageWithFileSend != null)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return ChatAttachmentDialog(
                                  sendMessageWithFile:
                                      (messageType, pickedFile, message) {
                                    widget.onMessageWithFileSend!
                                        .call(message, pickedFile, messageType);
                                  },
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: ApplicationColours.themeBlueColor,
                            foregroundColor: Colors.white,
                            child: SvgPicture.asset(
                              SVGAssetsImages.chatAttachment,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ChatCameraDialogButton(
                          sendMessageWithFile:
                              (messageType, pickedFile, message) {
                            widget.onMessageWithFileSend!
                                .call(message, pickedFile, messageType);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          StatefulBuilder(
            builder: (context, buttonState) {
              return widget.alwaysEnableSendButton ||
                      messageController.text.trim().isNotEmpty
                  ?
                  //Show the send button
                  GestureDetector(
                      onTap: widget.disableSend
                          ? null
                          : () {
                              if (widget.alwaysEnableSendButton ||
                                  messageController.text.trim().isNotEmpty) {
                                if (widget.closeKeyboardAfterMessageSend) {
                                  FocusScope.of(context).unfocus();
                                }
                                buttonState(() {
                                  widget.onTextMessageSend
                                      .call(messageController.text.trim());
                                  messageController.clear();
                                });
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  : widget.onMessageWithFileSend != null
                      ?
                      //Show the mic icon
                      // GestureDetector(
                      //     onTap: () async {
                      //       context
                      //           .read<MediaPlayerControllerCubit>()
                      //           .stopAllMedia(playMediaAfterAllStop: true);
                      //       // await openRecorderDialog(context)
                      //       //     .then((audioFile) async {
                      //       //   if (audioFile != null) {
                      //       //     final fileExtension =
                      //       //         FileExtensionChecker.extractExtension(
                      //       //             audioFile.path);
                      //       //     final messageType = MessageType.setMessageType(
                      //       //         fileExtension.name);
                      //       //     await showDialog(
                      //       //       context: context,
                      //       //       builder: (_) {
                      //       //         return ViewFilewidget(
                      //       //           file: audioFile,
                      //       //           fileExtension: fileExtension,
                      //       //           onMessageSend: (message) {
                      //       //             widget.onMessageWithFileSend!.call(
                      //       //                 message, audioFile, messageType);
                      //       //           },
                      //       //         );
                      //       //       },
                      //       //     );
                      //       //   }
                      //       // });
                      //     },
                      //     child: CircleAvatar(
                      //       backgroundColor:
                      //           ApplicationColours.themeLightPinkColor,
                      //       foregroundColor: Colors.white,
                      //       child: const Icon(Icons.mic),
                      //     ),
                      //   )
                      //TODO: Implement the audio recording feature
                      const SizedBox.shrink()
                      : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
