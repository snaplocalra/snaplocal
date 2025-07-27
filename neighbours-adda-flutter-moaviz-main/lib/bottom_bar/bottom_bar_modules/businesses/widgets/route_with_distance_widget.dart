import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class RouteWithDistance extends StatelessWidget {
  const RouteWithDistance({
    super.key,
    required this.distance,
    this.iconSize = 11,
    this.fontSize = 10,
  });

  final double iconSize;
  final double fontSize;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          SVGAssetsImages.route,
          fit: BoxFit.cover,
          height: iconSize,
        ),
        const SizedBox(width: 2),
        Text(
          distance,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(112, 112, 112, 1),
          ),
        ),
      ],
    );
  }
}
