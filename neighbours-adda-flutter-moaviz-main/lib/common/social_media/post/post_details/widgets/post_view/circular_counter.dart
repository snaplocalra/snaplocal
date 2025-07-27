import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class CircularCounter extends StatelessWidget {
  final num number;
  const CircularCounter({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xffeef2ff),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number.formatNumber(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}