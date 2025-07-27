import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SquareBorderSvgButton extends StatelessWidget {
  final bool showloading;
  final String svgImage;
  final String text;
  final double? space;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function()? onTap;

  const SquareBorderSvgButton({
    super.key,
    required this.svgImage,
    required this.text,
    this.showloading = false,
    this.space,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showloading ? null : onTap,
      child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset:
                  const Offset(0, 3), // changed the offset to give a 3D effect
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SvgPicture.asset(
                svgImage,
                fit: BoxFit.fitWidth,
                height: 40,
                width: 40,
                colorFilter: ColorFilter.mode(
                  foregroundColor ?? ApplicationColours.themeBlueColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (!showloading)
              Padding(
                padding: EdgeInsets.only(bottom: space ?? 5),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foregroundColor ?? ApplicationColours.themeBlueColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (showloading)
              Padding(
                padding: EdgeInsets.only(bottom: space ?? 5),
                child: ThemeSpinner(
                  key: const Key("spinner"),
                  size: 16,
                  color: foregroundColor ?? ApplicationColours.themeBlueColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
