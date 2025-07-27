import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

Future<bool?> showPermanentPermissionDeniedHandlerDialog(
  BuildContext context, {
  required String message,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog.adaptive(
        content: Text(tr(message), style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () async {
              await openAppSettings().whenComplete(
                () => // Close the dialog
                    Navigator.pop(context, true),
              );
            },
            child: const Text(
              "Open setting",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.pop(context, true);
            },
            child: Text(
              tr(LocaleKeys.cancel),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
