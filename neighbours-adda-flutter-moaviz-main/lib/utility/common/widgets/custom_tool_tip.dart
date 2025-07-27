// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class CustomToolTip extends StatelessWidget {
  final Widget child;
  final String message;
  final TooltipTriggerMode? triggerMode;
  const CustomToolTip({
    super.key,
    required this.child,
    required this.message,
    this.triggerMode,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: triggerMode,
      margin: EdgeInsets.zero,
      textStyle:
          TextStyle(color: ApplicationColours.themeBlueColor, fontSize: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      preferBelow: true,
      message: message,
      child: child,
    );
  }
}
