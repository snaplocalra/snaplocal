import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class StripWidget extends StatelessWidget {
  final StripWidgetType type;
  final bool reverseAngle;
  const StripWidget({
    super.key,
    required this.type,
    this.reverseAngle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: reverseAngle
              ? 180 * 3.14159 / 180 // Convert degree to radian
              : 0,
          child: SvgPicture.asset(
            type.svgPath,
            height: 20,
          ),
        ),
        Text(
          tr(type.title),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

enum StripWidgetType {
  open(svgPath: SVGAssetsImages.greenStrip, title: 'OPEN'),
  bought(svgPath: SVGAssetsImages.greenStrip, title: LocaleKeys.interested),
  soldOut(svgPath: SVGAssetsImages.redStrip, title: 'SOLD OUT'),
  applied(svgPath: SVGAssetsImages.greenStrip, title: 'APPLIED'),
  closed(svgPath: SVGAssetsImages.redStrip, title: 'CLOSED');

  final String svgPath;
  final String title;

  const StripWidgetType({
    required this.svgPath,
    required this.title,
  });
}
