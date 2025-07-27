import 'package:flutter/material.dart';

class OpacityBoxesWidget extends StatelessWidget {
  final int count;
  final double boxSize;
  final int maxCount;

  const OpacityBoxesWidget({
    super.key,
    required this.count,
    required this.boxSize,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    // Limit the count to a maximum of 8
    final limitedCount = count > maxCount ? maxCount : count;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(limitedCount, (index) {
        // Calculate the opacity for each box
        final opacity = (index + 1) / maxCount;
        return Container(
          width: boxSize + 2,
          height: boxSize,
          margin: const EdgeInsets.all(1),
          color: Colors.white.withOpacity(opacity),
        );
      }),
    );
  }
}
