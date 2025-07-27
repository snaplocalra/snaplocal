import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgTextWidget extends StatelessWidget {
  final String svgImage;
  final double svgheight;
  final String prefixText;
  final String? suffixText;
  final TextStyle? prefixStyle;
  const SvgTextWidget({
    super.key,
    required this.svgImage,
    required this.prefixText,
    this.svgheight = 15,
    this.suffixText,
    this.prefixStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SvgPicture.asset(
            svgImage,
            height: svgheight,
          ),
          const SizedBox(width: 5),
          Text(
            prefixText,
            style: prefixStyle ?? const TextStyle(fontSize: 14),
          ),
          if (suffixText != null)
            Text(" : $suffixText", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
