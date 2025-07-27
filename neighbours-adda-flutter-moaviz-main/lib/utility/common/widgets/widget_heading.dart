// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class WidgetHeading extends StatelessWidget {
  final String title;
  const WidgetHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ApplicationColours.themeBlueColor,
      ),
    );
  }
}
