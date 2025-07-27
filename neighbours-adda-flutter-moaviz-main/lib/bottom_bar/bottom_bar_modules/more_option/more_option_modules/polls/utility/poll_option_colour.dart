import 'package:flutter/material.dart';

Color getPollOptionColor(int index) {
  final List<Color> colorList = [
    const Color.fromRGBO(254, 203, 145, 1),
    const Color.fromARGB(255, 132, 151, 240),
    const Color.fromRGBO(163, 245, 161, 1),
    const Color.fromRGBO(254, 238, 136, 1),
  ];
  return colorList[index];
}
