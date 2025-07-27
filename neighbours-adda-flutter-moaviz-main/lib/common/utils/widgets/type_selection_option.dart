import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class TypeSelectionOption extends StatelessWidget {
  final String title;
  final bool isSelected;

  const TypeSelectionOption({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? ApplicationColours.themeBlueColor.withOpacity(0.04)
            : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: isSelected
              ? ApplicationColours.themeBlueColor
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        tr(title),
        style: TextStyle(
          color: isSelected ? ApplicationColours.themeBlueColor : Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}
