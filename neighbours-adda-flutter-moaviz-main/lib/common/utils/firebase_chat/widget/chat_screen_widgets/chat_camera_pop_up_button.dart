import 'dart:io';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/view_file_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/video_compress_progress_viewer.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/file_format_checker.dart';

class ChatCameraDialogButton extends StatefulWidget {
  final Function(MessageType messageType, File pickedFile, String message)
      sendMessageWithFile;
  const ChatCameraDialogButton({
    super.key,
    required this.sendMessageWithFile,
  });

  @override
  State<ChatCameraDialogButton> createState() => _ChatCameraDialogButtonState();
}

class _ChatCameraDialogButtonState extends State<ChatCameraDialogButton> {
  final mediaPickCubit = MediaPickCubit();

  MessageType messageType = MessageType.text;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mediaPickCubit,
      child: Builder(builder: (context) {
        return BlocListener<MediaPickCubit, MediaPickState>(
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
                  Navigator.pop(context);
                },
              );
            } else if (state.dataLoading) {
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
          child: GestureDetector(
            onTap: () {
              //clean the existing media
              context.read<MediaPickCubit>().clearMedia();

              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<MediaPickCubit>(),
                  child: const CameraActionDialog(),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: ApplicationColours.themeBlueColor,
              child: SvgPicture.asset(
                SVGAssetsImages.chatCamera,
                height: 15,
                width: 15,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CameraActionDialog extends StatelessWidget {
  const CameraActionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionDialogOption(
              iconSize: 25,
              svgImage: SVGAssetsImages.camera,
              title: tr(LocaleKeys.camera),
              subtitle: "Take a photo",
              onTap: () async {
                context.read<MediaPickCubit>().clickImage(context);
              },
            ),
            ActionDialogOption(
              showdivider: false,
              iconSize: 20,
              svgImage: SVGAssetsImages.gallery,
              title: tr(LocaleKeys.gallery),
              subtitle: "Pick from gallery",
              onTap: () async {
                context
                    .read<MediaPickCubit>()
                    .pickGalleryMedia(context, type: FileType.image);
              },
            ),
          ],
        ),
      ),
    );
  }
}
