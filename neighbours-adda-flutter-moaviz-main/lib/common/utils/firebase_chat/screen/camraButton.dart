
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utility/constant/application_colours.dart';
import '../../../../utility/constant/assets_images.dart';
import '../model/msg_type_enum.dart';

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
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          widget.sendMessageWithFile(
            MessageType.image,
            File(image.path),
            "Camera photo",
          );
        }
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
    );
  }
}