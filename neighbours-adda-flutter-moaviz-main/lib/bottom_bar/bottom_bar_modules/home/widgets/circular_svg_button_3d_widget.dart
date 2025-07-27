import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';

class CircularSvgButton3D extends StatelessWidget {
  final String svgImage;
  final double height;
  final void Function()? onTap;
  const CircularSvgButton3D({
    super.key,
    required this.svgImage,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(195, 208, 248, 1),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: CircularSvgButton(
        onTap: onTap,
        svgImage: svgImage,
        circleRadius: 18,
        borderColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(238, 242, 255, 1),
      ),
    );
  }
}
