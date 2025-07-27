import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/names.dart';

class IntroductionTitleWidget extends StatelessWidget {
  const IntroductionTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome to $applicationName",
          style: const TextStyle(
            color: Color.fromRGBO(15, 26, 63, 1),
            fontSize: 20,
          ),
        ),
         Text(
          tr(LocaleKeys.stayConnectedWithYourNeighbours),
          style: const TextStyle(
            color: Color.fromRGBO(105, 102, 128, 1),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
