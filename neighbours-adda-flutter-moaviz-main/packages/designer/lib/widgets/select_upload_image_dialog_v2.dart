// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/config/theme_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectUploadImageDialogV2 extends StatelessWidget {
  final void Function() onCameraOption;
  final void Function() onGalleryOption;
  const SelectUploadImageDialogV2({
    super.key,
    required this.onCameraOption,
    required this.onGalleryOption,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.red,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        height: 100,
        width: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 25,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: ThemeColor.color,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            onCameraOption.call();
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
                          )),
                    )),
                const SizedBox(height: 4),
                const Text("Camera"),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 25,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: ThemeColor.color,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          onGalleryOption.call();
                        },
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          size: 20,
                          color: Colors.white,
                        )),
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Gallery")
              ],
            )
          ],
        ),
      ),
    );
  }
}
