import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/translation/locale_keys.g.dart'; // Assuming you are using easy_localization

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String message,
  required String confirmationButtonText,
  Color confirmationButtonColor = Colors.red,
  Color cancelButtonColor = Colors.black,
  String cancelButtonText = LocaleKeys.cancel,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      content: Text(
        tr(message),
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            tr(confirmationButtonText),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: confirmationButtonColor,
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            tr(cancelButtonText),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: cancelButtonColor,
              fontSize: 13,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      buttonPadding: const EdgeInsets.all(0),
    ),
  );
}
