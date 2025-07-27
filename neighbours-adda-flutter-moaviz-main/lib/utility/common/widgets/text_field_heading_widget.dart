import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldHeadingTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final bool showStarMark;
  final bool showOptional;
  const TextFieldHeadingTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.padding,
    this.showStarMark = false,
    this.showOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w400,
                color: color,
              ),
            ),
          ),

          //optional text
          Visibility(
            visible: showOptional && !showStarMark,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "(${tr(LocaleKeys.optional)})",
                style: TextStyle(
                  fontSize: fontSize != null ? fontSize! - 2 : 12,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(131, 133, 130, 1),
                ),
              ),
            ),
          ),

          //star mark
          Visibility(
            visible: showStarMark && !showOptional,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
