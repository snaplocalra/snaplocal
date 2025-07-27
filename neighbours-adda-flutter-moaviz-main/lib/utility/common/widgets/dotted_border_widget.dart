import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBorderWidget extends StatelessWidget {
  const DottedBorderWidget({
    super.key,
    required this.child,
    this.radius = const Radius.circular(0),
  });

  final Widget child;
  final Radius radius;
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: Colors.grey.shade300,
        strokeWidth: 1,
        radius: radius,
        dashPattern: const [3, 7],
        strokeCap: StrokeCap.round,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }
}
