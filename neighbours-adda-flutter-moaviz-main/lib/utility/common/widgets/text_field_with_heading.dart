import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';

class TextFieldWithHeading extends StatelessWidget {
  final String textFieldHeading;
  final Widget child;
  final bool showStarMark;
  final bool showOptional;
  final EdgeInsets? headingPadding;
  const TextFieldWithHeading({
    super.key,
    required this.textFieldHeading,
    required this.child,
    this.showStarMark = false,
    this.showOptional = false,
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
          showOptional: showOptional,
          fontWeight: FontWeight.w500,
        ),
        child,
      ],
    );
  }
}
