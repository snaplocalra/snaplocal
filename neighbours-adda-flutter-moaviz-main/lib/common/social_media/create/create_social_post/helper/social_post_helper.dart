import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SocialPostHelper {
  Future<void> openMarketPlacePostCreateScreen(
    BuildContext context, {
    required String screenName,
    required ProfileSettingsState profileSettingsState,
  }) async {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.socialMediaLocation !=
          null) {
        await GoRouter.of(context).pushNamed(screenName).then((value) {
          if (value == true && context.mounted) {
            GoRouter.of(context).pop();
          }
        });
      } else {
        await showThemeAlertDialog(
          context: context,
          onAcceptPressed: () {
            GoRouter.of(context).pushNamed(
              LocationManageMapScreen.routeName,
              extra: {
                "locationType": LocationType.marketPlace,
                "locationManageType": LocationManageType.setting,
              },
            );
          },
          agreeButtonText: "Update Now",
          cancelButtonText: tr(LocaleKeys.cancel),
          title: "You need to update your location to procced.",
        );
      }
    }
  }

  Future<void> openSocialPostCreateScreen(
    BuildContext context, {
    required String screenName,
    Object? extra,
  }) async {
    await GoRouter.of(context)
        .pushNamed(screenName, extra: extra)
        .then((value) {
      if (value == true && context.mounted) {
        GoRouter.of(context).pop();
      }
    });
  }
}
