import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/widgets/icon_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsSuccessDialog extends StatelessWidget {
  const NewsSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                SVGAssetsImages.verified,
                height: 100,
                width: 100,
              ),
            ),
            Text(
              tr(LocaleKeys.newsPostedSuccessfully),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              tr(LocaleKeys.thanksForSharing),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(
              thickness: 2,
              color: Color.fromRGBO(239, 239, 239, 1),
            ),
            IconTextWidget(text: tr(LocaleKeys.verifiedTextOne)),
            IconTextWidget(text: tr(LocaleKeys.verifiedTextTwo)),
            IconTextWidget(text: tr(LocaleKeys.verifiedTextThree)),
            const Divider(
              thickness: 2,
              color: Color.fromRGBO(239, 239, 239, 1),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 100,
                child: ThemeElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  buttonName: tr(LocaleKeys.okay),
                  textFontSize: 13,
                  backgroundColor: ApplicationColours.themeLightPinkColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
