import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TabTypeDescription extends StatelessWidget {
  const TabTypeDescription({
    super.key,
    required this.description,
    this.fontSize = 15,
  });
  final double fontSize;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        tr(description),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(175, 173, 173, 1),
        ),
      ),
    );
  }
}
