import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/pop_up_menu/models/pop_up_menu_type.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PopUpMenuChild extends StatelessWidget {
  final PopUpMenuType popUpMenuType;
  final String? text;
  final Widget? prefix;
  const PopUpMenuChild({
    super.key,
    required this.popUpMenuType,
    this.text,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (prefix != null || popUpMenuType.icon != null)
          prefix != null
              ? prefix!
              : Icon(
                  popUpMenuType.icon!,
                  color: ApplicationColours.themeBlueColor,
                  size: 16,
                ),
        const SizedBox(width: 5),
        Text(
          tr(text ?? popUpMenuType.name),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
