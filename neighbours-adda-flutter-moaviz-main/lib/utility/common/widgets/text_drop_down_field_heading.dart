import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';

class TextDropdownFieldWithHeading extends StatelessWidget {
  final String textFieldHeading;
  final Widget textFieldDropDownField;
  final bool showStarMark;
  final EdgeInsets? headingPadding;
  const TextDropdownFieldWithHeading({
    super.key,
    required this.textFieldHeading,
    required this.textFieldDropDownField,
    this.showStarMark = false,
    this.headingPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldHeadingTextWidget(
          padding: headingPadding ?? const EdgeInsets.symmetric(vertical: 6),
          text: textFieldHeading,
          showStarMark: showStarMark,
          fontWeight: FontWeight.w500,
        ),
        textFieldDropDownField,
      ],
    );
  }
}
