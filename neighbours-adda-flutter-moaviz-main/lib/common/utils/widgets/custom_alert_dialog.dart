import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class CustomAlertDialog extends StatelessWidget {
  final String svgImagePath;
  final String? title;
  final Color? titleColor;
  final String description;
  final Widget action;
  final bool disableSVGThemeBackground;
  final double iconSize;
  final double circleRadius;
  const CustomAlertDialog({
    super.key,
    required this.svgImagePath,
    this.title,
    required this.description,
    required this.action,
    this.disableSVGThemeBackground = false,
    this.iconSize = 35,
    this.circleRadius = 25,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      backgroundColor: Colors.white, // Set background color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularSvg(
              svgImage: svgImagePath,
              iconColor: Colors.white,
              disableIconColor: disableSVGThemeBackground,
              backgroundColor: disableSVGThemeBackground
                  ? null
                  : ApplicationColours.themePinkColor,
              borderColor: disableSVGThemeBackground
                  ? null
                  : ApplicationColours.themePinkColor,
              iconSize: iconSize,
              circleRadius: circleRadius,
            ),
            const SizedBox(height: 10),
            if (title != null)
              Text(
                tr(title!),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: titleColor,
                ),
              ),
            const SizedBox(height: 5),
            Text(
              tr(description),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Center(child: action),
          ],
        ),
      ),
    );
  }
}

Future<bool> showCustomAlertDialog(
  BuildContext context, {
  required String svgImagePath,
  String? title,
  required String description,
  required Widget action,
  bool barrierDismissible = true,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomAlertDialog(
      svgImagePath: svgImagePath,
      description: description,
      action: action,
      title: title,
    ),
  ).then((value) => value ?? false);
}
