import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ResetPasswordSuccessDialog extends StatelessWidget {
  const ResetPasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              SVGAssetsImages.resetPasswordSuccess,
              fit: BoxFit.scaleDown,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                tr(LocaleKeys.resetPasswordSuccessful),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(0, 25, 104, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ThemeElevatedButton(
                buttonName: tr(LocaleKeys.backToLogin),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
