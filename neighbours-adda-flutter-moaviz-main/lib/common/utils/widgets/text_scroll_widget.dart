import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class ExpandedTextScrollWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const ExpandedTextScrollWidget({
    super.key,
    this.style,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextScroll(
            text,
            style: style,
            velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
            delayBefore: const Duration(seconds: 2),
            pauseBetween: const Duration(seconds: 2),
            fadedBorder: true,
            fadedBorderWidth: 0.05,
            fadeBorderSide: FadeBorderSide.right,
          ),
        ),
      ],
    );
  }
}

class TextScrollWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const TextScrollWidget({
    super.key,
    this.style,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextScroll(
      text,
      style: style,
      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
      delayBefore: const Duration(seconds: 2),
      pauseBetween: const Duration(seconds: 2),
      fadedBorder: true,
      fadedBorderWidth: 0.05,
      fadeBorderSide: FadeBorderSide.right,
    );
  }
}
