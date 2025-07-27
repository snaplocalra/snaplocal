import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/screen/manage_sales_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/screen/manage_event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/screens/manage_poll_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/helper/social_post_helper.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/master_category_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/lost_found_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/regular_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/safety_alerts_post_screen.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class MasterCategoryList {
  final BuildContext context;
  MasterCategoryList(this.context);

  late List<MasterCategoryModel> categories = [
    MasterCategoryModel(
      name: tr(LocaleKeys.general),
      svgPath: SVGAssetsImages.general,
      isSelected: true,
      onTap: () async {},
    ),
    MasterCategoryModel(
      name: tr(LocaleKeys.lostAndFound),
      svgPath: SVGAssetsImages.lostFound,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: LostFoundPostScreen.routeName,
        );
      },
    ),
    MasterCategoryModel(
      name: "Safety",
      svgPath: SVGAssetsImages.safety,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: SafetyAlertPostScreen.routeName,
        );
      },
    ),
    MasterCategoryModel(
      name: tr(LocaleKeys.buyAndsell),
      svgPath: SVGAssetsImages.buySell,
      onTap: () async {
        await SocialPostHelper().openMarketPlacePostCreateScreen(
          context,
          screenName: ManageSalesPostScreen.routeName,
          profileSettingsState: context.read<ProfileSettingsCubit>().state,
        );
      },
    ),
    MasterCategoryModel(
      name: tr(LocaleKeys.createEvent),
      svgPath: SVGAssetsImages.createEvent,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: CreateEventScreen.routeName,
        );
      },
    ),
    MasterCategoryModel(
      name: tr(LocaleKeys.poll),
      svgPath: SVGAssetsImages.polls,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: ManagePollScreen.routeName,
        );
      },
    ),
    MasterCategoryModel(
      name: "Ask Question",
      svgPath: SVGAssetsImages.askQuestion,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: RegularPostScreen.routeName,
          extra: {
            'postType': PostType.askQuestion,
          },
        );
      },
    ),
    MasterCategoryModel(
      name: "Ask Suggestion",
      svgPath: SVGAssetsImages.askRecommendation,
      onTap: () async {
        await SocialPostHelper().openSocialPostCreateScreen(
          context,
          screenName: RegularPostScreen.routeName,
          extra: {
            'postType': PostType.askSuggestion,
          },
        );
      },
    ),
  ];
}
