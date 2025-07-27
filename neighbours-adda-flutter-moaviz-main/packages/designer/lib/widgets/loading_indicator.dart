import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double strokeWidth;
  const LoadingIndicator({
    super.key,
    this.color,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: color ?? Theme.of(context).primaryColor,
          strokeWidth: strokeWidth,
        ),
      );
}
