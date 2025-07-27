// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PostSettingDisplay extends StatelessWidget {
  final String name;
  final String svgPath;
  final double? fontSize;
  final double? iconSize;
  const PostSettingDisplay({
    super.key,
    required this.name,
    required this.svgPath,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 242, 242, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            height: iconSize ?? 16,
            fit: BoxFit.scaleDown,
            colorFilter: ColorFilter.mode(
              ApplicationColours.themeBlueColor,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.16,
              child: Text(
                tr(name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 16,
                ),
              ),
            ),
          ),
          Icon(
            Icons.expand_more,
            color: ApplicationColours.themeBlueColor,
            size: 16,
            weight: 1,
          ),
        ],
      ),
    );
  }
}
