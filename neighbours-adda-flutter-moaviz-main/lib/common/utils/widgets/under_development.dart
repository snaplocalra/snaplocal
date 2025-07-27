import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/constant/errors.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';

class UnderDevelopmentWidget extends StatelessWidget {
  const UnderDevelopmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        //tr(LocaleKeys.underDevelopment),
        ErrorConstants.maintenanceMode,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
