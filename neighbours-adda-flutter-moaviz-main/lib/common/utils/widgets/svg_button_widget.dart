import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButtonWidget extends StatelessWidget {
  final String svgImage;
  final double svgSize;
  final ColorFilter? svgColorFilter;
  final void Function()? onTap;
  const SvgButtonWidget({
    super.key,
    required this.svgImage,
    this.svgSize = 20,
   
    this.svgColorFilter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AbsorbPointer(
        child: SvgPicture.asset(
          svgImage,
          fit: BoxFit.fitWidth,
          height: svgSize,
          width: svgSize,
          colorFilter: svgColorFilter,
        ),
      ),
    );
  }
}
