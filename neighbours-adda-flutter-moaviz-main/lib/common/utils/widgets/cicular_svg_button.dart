import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSvgButton extends StatelessWidget {
  final String svgImage;
  final Color? iconColor;
  final Color? borderColor;
  final double iconSize;
  final Color? backgroundColor;
  final Color? loadingColor;
  final double circleRadius;
  final void Function()? onTap;
  final bool showLoading;
  const CircularSvgButton({
    super.key,
    required this.svgImage,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.circleRadius = 15,
    this.iconSize = 20,
    this.onTap,
    this.showLoading = false,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: showLoading ? null : onTap,
        child: CircleAvatar(
          radius: circleRadius,
          backgroundColor: borderColor ?? iconColor ?? Colors.white,
          child: CircleAvatar(
            backgroundColor: backgroundColor,
            radius: circleRadius - 1,
            child: showLoading
                ? ThemeSpinner(
                    size: circleRadius,
                    color: loadingColor ?? Colors.white,
                  )
                : SvgPicture.asset(
                    svgImage,
                    fit: BoxFit.fitWidth,
                    height: iconSize,
                    width: iconSize,
                    colorFilter: iconColor == null
                        ? null
                        : ColorFilter.mode(
                            iconColor!,
                            BlendMode.srcIn,
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}
