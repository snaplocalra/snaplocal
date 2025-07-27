import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class ActionDialogOption extends StatelessWidget {
  final String svgImage;
  final String title;
  final String? subtitle;
  final double iconSize;
  final VoidCallback onTap;
  final bool showdivider;

  const ActionDialogOption({
    super.key,
    required this.svgImage,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconSize = 25,
    this.showdivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap.call();
      },
      child: AbsorbPointer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  SvgPicture.asset(
                    svgImage,
                    height: iconSize,
                    width: iconSize,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color.fromRGBO(126, 126, 126, 1),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showdivider,
              child: const ThemeDivider(thickness: 1),
            ),
          ],
        ),
      ),
    );
  }
}
