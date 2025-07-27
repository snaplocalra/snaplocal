import 'package:designer/config/theme_colour.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ThemeToast {
  static Future<void> successToast(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: ThemeColor.color,
    );
  }

  static Future<void> errorToast(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
    );
  }
}
