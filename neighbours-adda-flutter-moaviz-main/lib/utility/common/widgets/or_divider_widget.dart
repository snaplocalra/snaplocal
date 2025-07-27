import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ORDivider extends StatelessWidget {
  final double dividerHeight;
  final double? dividerThickness;
  final Color? dividerColor;
  final Color? textColor;
  final double textFontSize;
  const ORDivider({
    super.key,
    this.dividerHeight = 0,
    this.dividerThickness,
    this.dividerColor,
    this.textColor,
    this.textFontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ?? const Color.fromRGBO(167, 156, 158, 1),
            height: dividerHeight,
            thickness: dividerThickness,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            tr(LocaleKeys.or),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: textFontSize,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ?? const Color.fromRGBO(167, 156, 158, 1),
            height: dividerHeight,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}
