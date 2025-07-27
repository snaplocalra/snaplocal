import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/constant/url_links.dart';

class AgreementWidget extends StatelessWidget {
  final AgreemenFrom agreemenFrom;
  const AgreementWidget({
    super.key,
    required this.agreemenFrom,
  });

  @override
  Widget build(BuildContext context) {
    const linkTextStyle = TextStyle(
      color: Colors.indigo,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline,
    );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        children: [
          agreemenFrom == AgreemenFrom.chooseAuthScreen
              ? TextSpan(text: "${tr(LocaleKeys.youAgreeToOur)} ")
              : TextSpan(text: "${tr(LocaleKeys.bySignUpYouAgreeToOur)} "),
          TextSpan(
            text: tr(LocaleKeys.termsAndConditions),
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                UrlLauncher().openWebsite(termsCondition);
              },
          ),
          TextSpan(text: " ${tr(LocaleKeys.andThatYouHaveReadOur)} "),
          TextSpan(
            text: tr(LocaleKeys.privacyPolicy),
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                UrlLauncher().openWebsite(privacyPolicy);
              },
          ),
          const TextSpan(text: ".")
        ],
      ),
    );
  }
}

enum AgreemenFrom {
  chooseAuthScreen,
  signupScreen,
}
