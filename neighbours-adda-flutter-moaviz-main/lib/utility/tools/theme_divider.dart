// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ThemeDivider extends StatelessWidget {
  final double? height;
  final double thickness;
  const ThemeDivider({
    super.key,
    this.height,
    this.thickness = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      height: height,
      color: const Color.fromRGBO(248, 246, 246, 1),
    );
  }
}
