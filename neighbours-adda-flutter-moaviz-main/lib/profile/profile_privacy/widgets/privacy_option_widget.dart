import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PrivacyOptionWidget extends StatelessWidget {
  final String name;
  final String svgIconPath;
  final String description;

  final bool isSelected;
  const PrivacyOptionWidget({
    super.key,
    required this.name,
    required this.svgIconPath,
    required this.description,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              svgIconPath,
              colorFilter: isSelected
                  ? ColorFilter.mode(
                      ApplicationColours.themeBlueColor,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              tr(name),
              style: TextStyle(
                color:
                    isSelected ? const Color.fromRGBO(242, 58, 156, 1) : null,
                fontSize: 16,
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Text(
          tr(description),
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
