import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class BeTheFirstLike extends StatelessWidget {
  const BeTheFirstLike({
    super.key,
    this.onTap,
    required this.visible,
  });

  final void Function()? onTap;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(225, 231, 249, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              tr(LocaleKeys.beTheFirstLike),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
