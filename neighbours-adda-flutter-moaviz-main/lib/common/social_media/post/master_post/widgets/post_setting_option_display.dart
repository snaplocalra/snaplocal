import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PostSettingOptionDisplay extends StatelessWidget {
  final String svgPath;
  final String name;
  final bool isSelected;
  const PostSettingOptionDisplay({
    super.key,
    required this.name,
    required this.svgPath,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? ApplicationColours.themeGreenColor : Colors.black;
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          height: 18,
          colorFilter: isSelected
              ? ColorFilter.mode(color, BlendMode.srcIn)
              : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            tr(name),
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Icon(
            Icons.check,
            color: color,
            size: 14,
            weight: 15,
          ),
        ),
      ],
    );
  }
}
