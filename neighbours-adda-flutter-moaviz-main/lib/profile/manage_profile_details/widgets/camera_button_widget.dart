// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class CircleCameraButton extends StatelessWidget {
  final void Function() onTap;
  const CircleCameraButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () async {
        await HapticFeedback.lightImpact();
        onTap.call();
      },
      child: CircleAvatar(
        radius: mqSize.width * 0.05,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: mqSize.width * 0.045,
          backgroundColor: ApplicationColours.themeBlueColor,
          child: SvgPicture.asset(
            SVGAssetsImages.camera,
            height: mqSize.height * 0.03,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
