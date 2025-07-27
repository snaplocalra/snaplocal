import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareButton extends StatelessWidget {
  final String buttonText;
  final double buttonTextSize;
  final Color textColor;
  final String? svgAsset;
  final Color svgColor; // New property for SVG color
  final void Function()? onTap;
  final Decoration decoration;
  final double svgSize;
  const SquareButton({
    super.key,
    this.buttonTextSize = 13,
    required this.buttonText,
    required this.textColor,
    required this.decoration,
    this.svgAsset,
    required this.onTap,
    this.svgSize = 24.0,
    this.svgColor = Colors.black, // Default SVG color
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
        decoration: decoration,
        child: Row(
          children: [
            if (svgAsset != null)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
                  child: SvgPicture.asset(
                    svgAsset!,
                    width: svgSize,
                    height: svgSize,
                  ),
                ),
              ),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: buttonTextSize,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
