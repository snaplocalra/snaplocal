import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ChatScreenContactWidget extends StatelessWidget {
  final String name;
  final String? image;
  final void Function()? onTap;
  const ChatScreenContactWidget({
    super.key,
    required this.name,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Row(
          children: [
            OctagonWidget(
              shapeSize: 40,
              child: image == null
                  ? const AssetImageCircleAvatar(
                      radius: 20,
                      imageurl: PNGAssetsImages.defaultAvatar,
                    )
                  : NetworkImageCircleAvatar(
                      radius: 20,
                      imageurl: image!,
                    ),
            ),
            const SizedBox(width: 5),
            Text(
              name,
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
