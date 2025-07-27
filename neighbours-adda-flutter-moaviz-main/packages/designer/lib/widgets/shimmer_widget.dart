import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  // ignore: use_key_in_widget_constructors
  const ShimmerWidget({
    required this.height,
    required this.width,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade50,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            shape: shapeBorder,
            color: Colors.grey.shade400,
          ),
        ),
      );
}
