import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgElevatedButton extends StatelessWidget {
  final void Function() onTap;
  final String svgImage;
  final String name;
  final double textSize;
  final double boxHeight;
  final Color backgroundcolor;
  const SvgElevatedButton({
    super.key,
    required this.onTap,
    required this.svgImage,
    required this.name,
    this.textSize = 12,
    this.boxHeight = 25,
    required this.backgroundcolor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: boxHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgImage,
              height: textSize,
            ),
            const SizedBox(width: 5),
            Text(
              tr(name),
              style: TextStyle(
                fontSize: textSize,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
