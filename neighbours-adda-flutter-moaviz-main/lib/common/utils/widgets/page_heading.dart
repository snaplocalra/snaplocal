import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageHeading extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String svgPath;

  const PageHeading({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        svgPath!='null'?CircleAvatar(
          backgroundColor: const Color.fromRGBO(233, 237, 255, 1),
          radius: 25,
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.fitWidth,
            height: 25,
          ),
        ):const SizedBox.shrink(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr(heading),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              Text(
                tr(subHeading),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(131, 133, 130, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
