import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ChatDeleteOptionWidget extends StatelessWidget {
  final VoidCallback? onDeleteForEveryone;
  final VoidCallback onDeleteForMe;

  const ChatDeleteOptionWidget({
    super.key,
    this.onDeleteForEveryone,
    required this.onDeleteForMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onDeleteForEveryone != null)
          ListTile(
            iconColor: Colors.red,
            leading: const Icon(Icons.delete_forever),
            title: Text(tr(LocaleKeys.deleteForEveryone)),
            onTap: () {
              onDeleteForEveryone!.call();
              Navigator.pop(context);
            },
          ),
        ListTile(
          iconColor: Colors.red,
          leading: const Icon(Icons.delete),
          title: Text(tr(LocaleKeys.deleteForMe)),
          onTap: () {
            onDeleteForMe.call();
            Navigator.pop(context);
          },
        ),
        ListTile(
          iconColor: ApplicationColours.themeBlueColor,
          leading: const Icon(Icons.cancel),
          title: Text(tr(LocaleKeys.cancel)),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
