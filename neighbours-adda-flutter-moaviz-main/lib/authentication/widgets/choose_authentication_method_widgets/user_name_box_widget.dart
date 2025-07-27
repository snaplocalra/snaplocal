import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserNameBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  const UserNameBoxWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(191, 188, 188, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              tr(LocaleKeys.phoneNumberOrEmail),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(191, 188, 188, 1),
            height: 0,
            thickness: 1,
          ),
          TextFormField(
            key: const Key("VerifyUserNameTextField"),
            controller: controller,
            autofillHints: const [
              AutofillHints.telephoneNumberLocalSuffix,
              AutofillHints.email,
            ],
            inputFormatters: [
              // LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
              // FilteringTextInputFormatter.digitsOnly,
            ],
            decoration:  InputDecoration(
              hintText: tr(LocaleKeys.enterYourName),
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: const UnderlineInputBorder(
                // Remove underline color
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: const UnderlineInputBorder(
                // Remove underline color
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
