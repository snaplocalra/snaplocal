import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoreOptionRow extends StatelessWidget {
  final MoreOptionWidget leftOption;
  final MoreOptionWidget? rightOption;
  const MoreOptionRow({
    super.key,
    required this.leftOption,
    this.rightOption,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: leftOption),
        if (rightOption == null) const Spacer(),
        if (rightOption != null) Expanded(child: rightOption!),
      ],
    );
  }
}

class MoreOptionWidget extends StatelessWidget {
  final String name;
  final String svgImagePath;
  final void Function() onTap;

  const MoreOptionWidget({
    super.key,
    required this.name,
    required this.svgImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              svgImagePath,
              height: 35,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Text(
              tr(name),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
