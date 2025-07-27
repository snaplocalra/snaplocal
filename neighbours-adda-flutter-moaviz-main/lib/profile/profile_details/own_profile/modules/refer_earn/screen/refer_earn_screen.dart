import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});
  static const routeName = 'refer_earn';

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ThemeAppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.refer),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SVGAssetsImages.refer,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: ApplicationColours.themePinkColor,
                    strokeWidth: 1,
                    radius: const Radius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      tr(LocaleKeys.inviteFriendsUsingYourReferralLinkToSnapLocalAndEarn100PointsForEachNewMemberWhoSignsUpYourFriendsWhoDownloadUsingYourLinkWillAlsoReceive100PointsUponSignUp),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: ThemeElevatedButton(
            buttonName: tr(LocaleKeys.share),
            showLoadingSpinner: false,
            disableButton: false,
            onPressed: () async {
              final RenderBox box = context.findRenderObject() as RenderBox;
              await Share.share(
                'Invite friends using your referral link to Snap Local and earn 100 points for each new member who signs up. Your friends who download using your link will also receive 100 points upon sign-up.\n\nhttps://play.google.com/store/apps/details?id=com.na.snaplocal',
                subject: "Refer & Earn",
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
              );
            },
          ),
        ),
      ),
    );
  }
}
