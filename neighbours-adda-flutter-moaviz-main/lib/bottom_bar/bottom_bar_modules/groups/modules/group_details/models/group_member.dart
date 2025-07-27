import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/widget/group_detail_widget.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_list_impl.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_type.dart';
import 'package:snap_local/profile/profile_settings/models/profile_settings_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class GroupMember implements FollowerListImpl {
  final String groupName;
  final String groupPrivacyType;
  final String category;
  final int followerCount;
  final String descrption;
  final bool showFollower;
  final bool isVerified;
  final bool isPageAdmin;
  final ProfileSettingsModel profileSettingsModel;

  GroupMember({
    required this.groupName,
    required this.groupPrivacyType,
    required this.category,
    required this.followerCount,
    required this.descrption,
    required this.showFollower,
    required this.isVerified,
    required this.isPageAdmin,
    required this.profileSettingsModel,
  });

  @override
  bool get isAdmin => isPageAdmin;

  @override
  FollowersFrom get followerFrom => FollowersFrom.group;

  @override
  String get title => tr(LocaleKeys.groupMembers);

  @override
  Widget heading(BuildContext context) {
    return GroupDetailWidget(
      horizontalPadding: 10,
      groupName: groupName,
      isVerified: isVerified,
      groupPrivacyType: groupPrivacyType,
      category: category,
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
