import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/widgets/custom_alert_dialog.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/screens/edit_profile_screen.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

Future<void> showProfileFillDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return CustomAlertDialog(
        iconSize: 80,
        circleRadius: 40,
        svgImagePath: SVGAssetsImages.greenCircleTick,
        title: tr(LocaleKeys.completeyourprofile),
        titleColor: ApplicationColours.themeLightPinkColor,
        description: tr(LocaleKeys.pleasecompleteyourprofiletocontinue),
        disableSVGThemeBackground: true,
        action: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ThemeElevatedButton(
                  height: 40,
                  backgroundColor: ApplicationColours.themeBlueColor,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    GoRouter.of(context).pushNamed(EditProfileScreen.routeName);
                    Navigator.pop(context, true);
                  },
                  buttonName: tr(LocaleKeys.completeNow),
                  textFontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  tr(LocaleKeys.later),
                  style: TextStyle(
                    color: ApplicationColours.themeBlueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) async {
    if (value != null && value == true && context.mounted) {
      context
          .read<ManageProfileDetailsBloc>()
          .add(const SetShowProfileComplete());
    }
  });
}
