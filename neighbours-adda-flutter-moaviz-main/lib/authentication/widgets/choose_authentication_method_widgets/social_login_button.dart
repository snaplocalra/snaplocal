// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String svgImage;
  final void Function() onTap;
  final bool disable;
  final bool enableBorder;
  final double size;
  const SocialLoginButton({
    super.key,
    required this.svgImage,
    required this.onTap,
    this.disable = false,
    this.enableBorder = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: disable ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: enableBorder
                ? Border.all(color: Colors.black, width: 0.1)
                : null,
          ),
          child: ClipOval(
            child: SvgPicture.asset(
              svgImage,
              height: size,
              width: size,
            ),
          ),
        ),
      ),
    );
  }
}
