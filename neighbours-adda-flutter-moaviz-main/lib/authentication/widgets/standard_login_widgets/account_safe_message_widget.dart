import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class AccountSafeMessageWidget extends StatelessWidget {
  const AccountSafeMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Icon(
          FeatherIcons.lock,
          color: Color.fromRGBO(0, 25, 104, 1),
          size: 18,
        ),
        const SizedBox(width: 5),
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "${tr(LocaleKeys.yourinformationis)} ",
            style: const TextStyle(
              color: Color.fromRGBO(0, 25, 104, 1),
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: tr(LocaleKeys.safeandsecure),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]))
      ],
    );
  }
}
