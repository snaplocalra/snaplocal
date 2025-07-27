import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class PickedImageWidget extends StatelessWidget {
  const PickedImageWidget({
    super.key,
    required this.file,
    required this.onMediaRemove,
  });

  final File file;
  final void Function() onMediaRemove;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showImageViewer(
              context,
              FileImage(file),
              swipeDismissible: true,
              doubleTapZoomable: true,
              backgroundColor: Colors.black,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.file(
              file,
              height: mqSize.height * 0.15,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onMediaRemove.call();
            },
            child: Icon(
              Icons.cancel_sharp,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
