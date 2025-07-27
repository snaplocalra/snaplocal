import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  const ScreenHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ApplicationColours.themeBlueColor,
      ),
    );
  }
}
