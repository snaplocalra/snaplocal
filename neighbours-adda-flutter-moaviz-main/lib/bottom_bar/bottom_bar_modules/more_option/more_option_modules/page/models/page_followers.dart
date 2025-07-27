import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/widgets/page_details_widget.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_list_impl.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_type.dart';
import 'package:snap_local/profile/profile_settings/models/profile_settings_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PageFollowers implements FollowerListImpl {
  final String pageName;
  final String category;
  final int followerCount;
  final String descrption;
  final bool showFollower;
  final bool isPageAdmin;
  final bool isVerified;
  final ProfileSettingsModel profileSettingsModel;
  PageFollowers({
    required this.pageName,
    required this.category,
    required this.followerCount,
    required this.descrption,
    required this.showFollower,
    required this.isPageAdmin,
    required this.profileSettingsModel,
    required this.isVerified,
  });

  @override
  bool get isAdmin => isPageAdmin;

  @override
  FollowersFrom get followerFrom => FollowersFrom.page;

  @override
  String get title => tr(LocaleKeys.pageFollowers);

  @override
  Widget heading(BuildContext context) {
    return PageDetailWidget(
      horizontalPadding: 10,
      pageName: pageName,
      category: category,
      isVerified: isVerified,
      followerCount: followerCount,
      description: descrption,
      showFollower: showFollower,


    );
  }

  @override
  LatLng get latLng => LatLng(
        profileSettingsModel.socialMediaLocation!.latitude,
        profileSettingsModel.socialMediaLocation!.longitude,
      );

  @override
  double get searchRadius =>
      profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;
}
