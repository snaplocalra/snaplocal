import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SavedItemDataHeading extends StatelessWidget {
  final String text;
  final bool visible;
  const SavedItemDataHeading({
    super.key,
    required this.text,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 10),
        child: Text(
          tr(text),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ApplicationColours.themeBlueColor,
          ),
        ),
      ),
    );
  }
}
