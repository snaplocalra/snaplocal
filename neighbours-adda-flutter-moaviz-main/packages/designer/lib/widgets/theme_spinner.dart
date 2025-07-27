import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ThemeSpinner extends StatelessWidget {
  final Color? color;
  final double size;
  final double? height;
  final double? width;

  const ThemeSpinner({
    super.key,
    this.color,
    this.size = 50,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: SpinKitCircle(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}
