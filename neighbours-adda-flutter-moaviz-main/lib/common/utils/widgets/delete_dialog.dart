import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/custom_alert_dialog.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

Future<bool> showDeleteAlertDialog(
  BuildContext context, {
  required String description,
  bool barrierDismissible = true,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomAlertDialog(
      svgImagePath: SVGAssetsImages.delete,
      description: description,
      action: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThemeElevatedButton(
            buttonName: tr(LocaleKeys.yes),
            textFontSize: 12,
            padding: EdgeInsets.zero,
            width: 100,
            height: 35,
            onPressed: () {
              Navigator.of(context).pop(true); // Delete
            },
            foregroundColor: Colors.white,
            backgroundColor: ApplicationColours.themeBlueColor,
          ),
          const SizedBox(width: 5),
          ThemeElevatedButton(
            buttonName: tr(LocaleKeys.cancel),
            textFontSize: 12,
            padding: EdgeInsets.zero,
            width: 100,
            height: 35,
            onPressed: () {
              Navigator.of(context).pop(false); // cancel
            },
            foregroundColor: Colors.white,
            backgroundColor: ApplicationColours.themeBlueColor,
          ),
        ],
      ),
      title: tr(LocaleKeys.confirmDeletion),
    ),
  ).then((value) => value ?? false);
}
