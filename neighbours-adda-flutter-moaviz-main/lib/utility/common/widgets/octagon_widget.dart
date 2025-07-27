import 'dart:math';

import 'package:flutter/material.dart';

class OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double sideLength =
        width / (1 + sqrt(2)); // Calculate side length for equal sides
    double offset = (width - sideLength) / 2;

    Path path = Path();
    path.moveTo(offset, 0); // Top left
    path.lineTo(width - offset, 0); // Top right
    path.lineTo(width, offset); // Right top
    path.lineTo(width, height - offset); // Right bottom
    path.lineTo(width - offset, height); // Bottom right
    path.lineTo(offset, height); // Bottom left
    path.lineTo(0, height - offset); // Left bottom
    path.lineTo(0, offset); // Left top
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OctagonBorderPainter extends CustomPainter {
  final Color borderColor;
  final double strokeWidth;

  OctagonBorderPainter({required this.borderColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Path octagonPath = OctagonClipper().getClip(size);
    canvas.drawPath(octagonPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OctagonWidget extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double shapeSize;

  const OctagonWidget({
    super.key,
    required this.child,
    this.borderColor = Colors.white,
    this.borderWidth = 5,
    this.shapeSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: OctagonClipper(),
          child: SizedBox(
            height: shapeSize,
            width: shapeSize,
            child: child,
          ),
        ),
        CustomPaint(
          size: Size(shapeSize, shapeSize),
          painter: OctagonBorderPainter(
            borderColor: borderColor,
            strokeWidth: borderWidth,
          ),
        ),
      ],
    );
  }
}
