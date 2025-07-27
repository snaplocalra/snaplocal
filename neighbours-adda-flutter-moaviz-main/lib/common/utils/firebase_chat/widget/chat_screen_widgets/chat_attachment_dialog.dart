import 'dart:io';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/view_file_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/video_compress_progress_viewer.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/file_format_checker.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class ChatAttachmentDialog extends StatefulWidget {
  final Function(MessageType messageType, File pickedFile, String message)
      sendMessageWithFile;
  const ChatAttachmentDialog({
    super.key,
    required this.sendMessageWithFile,
  });

  @override
  State<ChatAttachmentDialog> createState() => _ChatAttachmentDialogState();
}

class _ChatAttachmentDialogState extends State<ChatAttachmentDialog> {
  final mediaPickCubit = MediaPickCubit();

  MessageType messageType = MessageType.text;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mediaPickCubit,
      child: Builder(builder: (context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: BlocListener<MediaPickCubit, MediaPickState>(
            listener: (context, state) async {
              final pickedFileList = state.mediaPickerModel.pickedFiles;

              if (pickedFileList.isNotEmpty) {
                final pickedFile = pickedFileList.first;
                final fileExtension =
                    FileExtensionChecker.extractExtension(pickedFile.file.path);

                messageType = MessageType.setMessageType(fileExtension.name);
                await showDialog(
                  context: context,
                  builder: (_) {
                    return ViewFilewidget(
                      file: pickedFile.file,
                      fileExtension: fileExtension,
                      onMessageSend: (message) {
                        widget.sendMessageWithFile(
                          messageType,
                          pickedFile.file,
                          message,
                        );
                      },
                    );
                  },
                ).whenComplete(
                  () {
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                );
              } else if (!state.mediaPickCancelled) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    if (messageType == MessageType.video) {
                      return const Dialog(
                        backgroundColor: Colors.white,
                        child: VideoCompressProgressViewer(),
                      );
                    } else {
                      return const ThemeSpinner();
                    }
                  },
                );
                return;
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    tr(LocaleKeys.whichItemWouldYouLikeToSelect),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const ThemeDivider(height: 10, thickness: 2),
                AddFileOptionWidget(
                  optionName: "Video",
                  optionSVG: SVGAssetsImages.chatVideo,
                  svgSize: 12,
                  onTap: () {
                    messageType = MessageType.video;
                    context
                        .read<MediaPickCubit>()
                        .pickGalleryMedia(context, type: FileType.video);
                  },
                ),
                const ThemeDivider(height: 10, thickness: 2),
                /*AddFileOptionWidget(
                  optionName: "Audio",
                  optionSVG: SVGAssetsImages.chatAudio,
                  svgSize: 18,
                  onTap: () {
                    messageType = MessageType.audio;

                    context
                        .read<MediaPickCubit>()
                        .pickGalleryMedia(context, type: FileType.audio);
                  },
                ),*/
                // const ThemeDivider(height: 10, thickness: 2),
                AddFileOptionWidget(
                  optionName: "Document",
                  optionSVG: SVGAssetsImages.chatDocument,
                  svgSize: 16,
                  onTap: () {
                    messageType = MessageType.pdf;

                    context
                        .read<MediaPickCubit>()
                        .pickFiles(allowedExtensions: ['pdf']);
                  },
                ),
                const ThemeDivider(height: 10, thickness: 2),
                AddFileOptionWidget(
                  optionName: tr(LocaleKeys.close),
                  svgSize: 12,
                  optionSVG: SVGAssetsImages.chatClose,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AddFileOptionWidget extends StatelessWidget {
  final void Function() onTap;
  final String optionName;
  final String optionSVG;
  final double svgSize;
  const AddFileOptionWidget({
    super.key,
    required this.optionName,
    required this.optionSVG,
    required this.onTap,
    this.svgSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                optionSVG,
                height: svgSize,
                width: svgSize,
              ),
              const SizedBox(width: 10),
              Text(
                optionName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
