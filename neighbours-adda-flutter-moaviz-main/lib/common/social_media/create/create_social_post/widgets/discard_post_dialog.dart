// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/custom_alert_dialog.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

Future<bool> showDiscardChangesDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => CustomAlertDialog(
      svgImagePath: SVGAssetsImages.disableComment,
      title: "${tr(LocaleKeys.discardPost)} ?",
      description: tr(LocaleKeys.yourPostWontBeSavedIfYouGoBack),
      action: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThemeElevatedButton(
            buttonName: tr(LocaleKeys.keepPosting),
            textFontSize: 12,
            padding: EdgeInsets.zero,
            width: 128,
            height: 33,
            onPressed: () {
              Navigator.of(context).pop(false); // Keep editing
            },
            foregroundColor: Colors.white,
            backgroundColor: ApplicationColours.themeBlueColor,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Discard
            },
            style: ButtonStyle(
              foregroundColor:
                  WidgetStatePropertyAll(ApplicationColours.themePinkColor),
            ),
            child: Text(
              tr(LocaleKeys.discard),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ),
  ).then((value) => value ?? false);
}
