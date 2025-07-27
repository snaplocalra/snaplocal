import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/send_message_widget.dart';
import 'package:snap_local/utility/media_player/widget/better_video_player_widget.dart';
import 'package:snap_local/utility/tools/file_format_checker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewFilewidget extends StatefulWidget {
  final File file;
  final FileExtension fileExtension;
  final void Function(String message) onMessageSend;
  const ViewFilewidget({
    super.key,
    required this.file,
    required this.fileExtension,
    required this.onMessageSend,
  });

  @override
  State<ViewFilewidget> createState() => _ViewFilewidgetState();
}

class _ViewFilewidgetState extends State<ViewFilewidget> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: widget.fileExtension == FileExtension.pdf
                ? SfPdfViewer.file(widget.file)
                : widget.fileExtension == FileExtension.image
                    ? Image.file(
                        widget.file,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: child,
                          );
                        },
                      )
                    : widget.fileExtension == FileExtension.video
                        ? BetterVideoPlayerWidget(videoFile: widget.file)
                        : const Center(child: Text("Unsupported File format")),
          ),
          Visibility(
            visible: widget.fileExtension != FileExtension.none,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SendMessageWidget(
                  closeKeyboardAfterMessageSend: true,
                  textEditingController: messageController,
                  alwaysEnableSendButton: true,
                  hint: "Add a caption...",
                  onTextMessageSend: (message) {
                    FocusScope.of(context).unfocus();
                    widget.onMessageSend.call(messageController.text.trim());
                    messageController.clear();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
