import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ProfilePrivacyModel extends Equatable {
  final ProfilePrivacyEnum profilePicturePrivacy;
  final ProfilePrivacyEnum searchPrivacy;
  final ProfilePrivacyEnum chatPrivacy;

  const ProfilePrivacyModel({
    required this.profilePicturePrivacy,
    required this.searchPrivacy,
    required this.chatPrivacy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profile_picture_privacy': profilePicturePrivacy.paramName,
      'search_privacy': searchPrivacy.paramName,
      'chat_privacy': chatPrivacy.paramName,
    };
  }

  factory ProfilePrivacyModel.fromMap(Map<String, dynamic> map) {
    return ProfilePrivacyModel(
      profilePicturePrivacy:
          ProfilePrivacyEnum.fromMap(map['profile_picture_privacy']),
      searchPrivacy: ProfilePrivacyEnum.fromMap(map['search_privacy']),
      chatPrivacy: ProfilePrivacyEnum.fromMap(map['chat_privacy']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilePrivacyModel.fromJson(String source) =>
      ProfilePrivacyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        profilePicturePrivacy,
        searchPrivacy,
        chatPrivacy,
      ];
}

enum ProfilePrivacyEnum {
  public(
    privacyName: LocaleKeys.public,
    privacyDescription: LocaleKeys.publicDescription,
    paramName: "public",
    svgIcon: "assets/images/profile/privacy/privacy_public.svg",
  ),
  nearByLocality(
    privacyName: LocaleKeys.nearbylocality,
    privacyDescription: LocaleKeys.nearbyLocalityDescription,
    paramName: "nearby_locality",
    svgIcon: "assets/images/profile/privacy/privacy_nearby_locality.svg",
  ),
  yourConnections(
    privacyName: LocaleKeys.yourConnections,
    privacyDescription: LocaleKeys.yourConnectionDescription,
    paramName: "your_connections",
    svgIcon: "assets/images/profile/privacy/privacy_your_connections.svg",
  ),
  yourGroups(
    privacyName: LocaleKeys.yourGroups,
    privacyDescription: LocaleKeys.yourGroupDescription,
    paramName: "your_groups",
    svgIcon: "assets/images/profile/privacy/privacy_your_group.svg",
  ),
  noOne(
    privacyName: LocaleKeys.noOne,
    privacyDescription: LocaleKeys.noOneDescription,
    paramName: "no_one",
    svgIcon: "assets/images/profile/privacy/privacy_no_one.svg",
  );

  final String privacyName;
  final String privacyDescription;
  final String paramName;
  final String svgIcon;
  const ProfilePrivacyEnum({
    required this.privacyName,
    required this.privacyDescription,
    required this.paramName,
    required this.svgIcon,
  });

  factory ProfilePrivacyEnum.fromMap(String privacy) {
    switch (privacy) {
      case "public":
        return public;
      case "nearby_locality":
        return nearByLocality;
      case "your_connections":
        return yourConnections;
      case "your_groups":
        return yourGroups;
      case "no_one":
        return noOne;
      default:
        return public;
    }
  }
}
