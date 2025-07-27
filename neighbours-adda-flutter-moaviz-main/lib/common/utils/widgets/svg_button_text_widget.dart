import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButtonTextWidget extends StatelessWidget {
  final String svgImage;
  final String? text;

  final double? svgHeight;
  final double? svgWidth;
  final ColorFilter? svgColorFilter;

  ///Space between SVG and Text
  final double? space;

  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onLongPressCancel;
  const SvgButtonTextWidget({
    super.key,
    required this.svgImage,
    this.text,
    this.svgHeight,
    this.svgWidth,
    this.svgColorFilter,
    this.space,
    this.onTap,
    this.onLongPress,
    this.onLongPressCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onLongPressCancel: onLongPressCancel,
        child: AbsorbPointer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgImage,
                fit: BoxFit.fitWidth,
                height: svgHeight,
                width: svgWidth,
                colorFilter: svgColorFilter,
              ),
              if (text != null)
                Padding(
                  padding: EdgeInsets.only(left: space ?? 4),
                  child: Text(
                    text!,
                    style: const TextStyle(
                      color: Color.fromRGBO(52, 45, 45, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
