import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSvg extends StatelessWidget {
  final String svgImage;
  final Color iconColor;
  final Color? borderColor;
  final double iconSize;
  final Color? backgroundColor;
  final double circleRadius;
  final bool disableIconColor;
  const CircularSvg({
    super.key,
    required this.svgImage,
    this.iconColor = Colors.white,
    this.borderColor,
    this.backgroundColor,
    this.circleRadius = 15,
    this.iconSize = 20,
    this.disableIconColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: CircleAvatar(
        radius: circleRadius,
        backgroundColor: borderColor ?? iconColor,
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          radius: circleRadius - 1,
          child: SvgPicture.asset(
            svgImage,
            fit: BoxFit.fitWidth,
            height: iconSize,
            width: iconSize,
            colorFilter: disableIconColor
                ? null
                : ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
          ),
        ),
      ),
    );
  }
}
