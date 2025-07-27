import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/profile/profile_details/own_profile/widget/pick_direct_profile_image_dialog.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class DirectEditPhotoButton extends StatelessWidget {
  final bool isCoverPic;
  const DirectEditPhotoButton({
    super.key,
    required this.isCoverPic,
  });

  @override
  Widget build(BuildContext context) {
    return CircularSvgButton(
      circleRadius: 12,
      iconSize: 15,
      svgImage: SVGAssetsImages.edit,
      iconColor: ApplicationColours.themeLightPinkColor,
      backgroundColor: Colors.white,
      borderColor: Colors.black,
      onTap: () {
        //show dialog to pick profile image
        showDialog(
          context: context,
          builder: (_) => PickDirectProfileImageDialog(
            isCoverPic: isCoverPic,
          ),
        );
      },
    );
  }
}
