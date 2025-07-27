// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectUploadImageDialogV1 extends StatefulWidget {
  final void Function() onCameraOption;
  final void Function() onGalleryOption;
  const SelectUploadImageDialogV1({
    super.key,
    required this.onCameraOption,
    required this.onGalleryOption,
  });

  @override
  State<SelectUploadImageDialogV1> createState() =>
      _SelectUploadImageDialogV1State();
}

class _SelectUploadImageDialogV1State extends State<SelectUploadImageDialogV1> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.grey.shade300),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 20),
                    child: Text(
                      "Select Upload Option",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      widget.onCameraOption.call();
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'packages/designer/assets/image_picker/camera.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.scaleDown,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Take Photo",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      widget.onGalleryOption.call();
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'packages/designer/assets/image_picker/gallery.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.fitHeight,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Choose from Gallery",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ThemeElevatedButton(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonName: "Cancel",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
