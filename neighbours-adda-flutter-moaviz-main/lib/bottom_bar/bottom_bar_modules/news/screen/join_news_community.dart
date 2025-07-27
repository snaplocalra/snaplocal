import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/screen/create_news_channel_screen.dart';
import 'package:snap_local/common/utils/widgets/icon_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class JoinNewsCommunityScreen extends StatelessWidget {
  static const routeName = 'join_news_community';

  const JoinNewsCommunityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: ThemeAppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBarHeight: 60,
        title: Text(
          tr(LocaleKeys.news),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(15, 20, 15, 50),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Text(
              tr(LocaleKeys.becomeANewsReporter),
              style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SvgPicture.asset(
              SVGAssetsImages.becomeANewsContributor,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            Text(
              tr(LocaleKeys.joinSnapLocalsNewsCommunityToday),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const IconTextWidget(text: LocaleKeys.joinNewsOne),
            const IconTextWidget(text: LocaleKeys.joinNewsTwo),
            const IconTextWidget(text: LocaleKeys.joinNewsThree),
            const IconTextWidget(text: LocaleKeys.joinnewsFour),
            const SizedBox(height: 10),
            ThemeElevatedButton(
              width: 200,
              onPressed: () {
                GoRouter.of(context).pop();
                GoRouter.of(context)
                    .pushNamed(CreateNewsChannelScreen.routeName);
              },
              buttonName: tr(LocaleKeys.continueButton),
              backgroundColor: ApplicationColours.themeLightPinkColor,
            ),
          ],
        ),
      ),
    );
  }
}
