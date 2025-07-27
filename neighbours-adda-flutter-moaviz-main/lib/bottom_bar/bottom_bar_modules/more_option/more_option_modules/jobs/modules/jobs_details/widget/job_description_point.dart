import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JobDescriptionPointWidget extends StatelessWidget {
  final String svgImage;
  final String title;
  final String value;
  const JobDescriptionPointWidget({
    super.key,
    required this.svgImage,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SvgPicture.asset(
              svgImage,
              fit: BoxFit.fitWidth,
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
