// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/profile_level/model/level_badge_model.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../utility/constant/errors.dart';

// ProfileDetailsModel profileDetailsFromJson(String str) =>
//     ProfileDetailsModel.fromJson(json.decode(str));

// String profileDetailsToJson(ProfileDetailsModel data) =>
//     json.encode(data.toJson());

class ProfileDetailsModel extends Equatable {
  final String id;
  final String name;
  final String? userType;
  final int? followersCount;
  final String? email;
  final String? mobile;
  final String profileImage;
  final String coverImage;
  final GenderEnum gender;
  final DateTime? dob;
  final String bio;
  final String workPlace;
  final String occupation;
  final bool isVerified;
  final bool showCompleteProfile;
  final bool isBlockedByYou;
  final bool isBlockedByNeighbour;
  final LanguageKnownList languageKnownList;
  final LocationAddressWithLatLng? location;
  final LevelBadgeModel levelBadgeModel;
  final ComplimentBadgeModel? complimentBadgeModel;

  const ProfileDetailsModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.followersCount,
    required this.email,
    required this.mobile,
    required this.profileImage,
    required this.coverImage,
    required this.gender,
    required this.occupation,
    required this.workPlace,
    required this.isVerified,
    required this.showCompleteProfile,
    required this.isBlockedByYou,
    required this.isBlockedByNeighbour,
    this.dob,
    required this.bio,
    required this.languageKnownList,
    this.location,
    required this.levelBadgeModel,
    this.complimentBadgeModel,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json, {required bool isOwnProfile}) {
    if (isDebug) {
      try {
        return _buildProfile(json, isOwnProfile: isOwnProfile);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildProfile(json, isOwnProfile: isOwnProfile);
    }
  }

  static ProfileDetailsModel _buildProfile(Map<String, dynamic> json, {required bool isOwnProfile}) =>
      ProfileDetailsModel(
        id: json["id"],
        name: json["name"],
        userType: json["user_type"],
        followersCount: json["followers_count"]??0,
        email: json["email"],
        mobile: json["mobile"],
        profileImage: json["image"],
        coverImage: json["cover_image"],
        occupation: json["occupation"] ?? "",
        workPlace: json["work_place"] ?? "",
        showCompleteProfile: json["show_complete_profile"] ?? false,
        gender: GenderEnum.fromJson(json["gender"]),
        dob: json["dob"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(int.parse(json["dob"])),
        bio: json["bio"] ?? "",
        languageKnownList: LanguageKnownList.fromMap(json),
        location: json["location"] == null
            ? null
            : LocationAddressWithLatLng.fromMap(json["location"]),
        levelBadgeModel: LevelBadgeModel.fromMap(json["level_badge"]),
        isVerified: json["is_verified"] ?? false,
        isBlockedByYou: json["is_blocked_by_you"] ?? false,
        isBlockedByNeighbour: json["is_blocked_by_neighbour"] ?? false,
        complimentBadgeModel: json["compliment_badge"] == null
            ? null
            : isOwnProfile
                ? OwnProfileComplimentBadge.fromMap(json["compliment_badge"])
                : ComplimentBadgeSender.fromMap(json["compliment_badge"]),
      );

  Map<String, dynamic> toJson({bool saveToDb = false}) {
    final profileDetailsMap = <String, dynamic>{
      "id": id,
      "name": name,
      "user_type": userType,
      "followers_count": followersCount,
      "email": email,
      "mobile": mobile,
      "image": saveToDb ? profileImage : profileImage.split('/').last,
      "cover_image": saveToDb ? coverImage : coverImage.split('/').last,
      "gender": gender.name,
      "occupation": occupation,
      "work_place": workPlace,
      "show_complete_profile": showCompleteProfile,
      if (dob != null) "dob": FormatDate.selectedDateYYYYMMDD(dob!),
      "bio": bio,
      "languages": languageKnownList.languages.map((e) => e.toMap()).toList(),
      "location": location?.toMap(),
      "is_verified": isVerified,
      "is_blocked_by_you": isBlockedByYou,
      "is_blocked_by_neighbour": isBlockedByNeighbour,
    };

    if (saveToDb) {
      profileDetailsMap.addAll({"level_badge": levelBadgeModel.toMap()});
    }

    return profileDetailsMap;
  }

  Map<String, dynamic> toFirebaseJson() {
    final profileDetailsMap = <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
      "mobile": mobile,
      "image": profileImage,
      "gender": gender.name,
    };

    return profileDetailsMap;
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      userType,
      email,
      mobile,
      profileImage,
      gender,
      dob,
      bio,
      languageKnownList,
      location,
      levelBadgeModel,
      occupation,
      workPlace,
      isVerified,
      showCompleteProfile,
      isBlockedByYou,
      isBlockedByNeighbour,
    ];
  }

  //copy with
  ProfileDetailsModel copyWith({
    String? id,
    String? name,
    String? userType,
    int? followersCount,
    String? email,
    String? mobile,
    String? profileImage,
    String? coverImage,
    GenderEnum? gender,
    DateTime? dob,
    String? bio,
    LanguageKnownList? languageKnownList,
    LocationAddressWithLatLng? location,
    LevelBadgeModel? levelBadgeModel,
    String? occupation,
    String? workPlace,
    bool? isVerified,
    bool? showCompleteProfile,
    bool? isBlockedByYou,
    bool? isBlockedByNeighbour,
  }) {
    return ProfileDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userType: userType ?? this.userType,
      followersCount: followersCount ?? this.followersCount,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      bio: bio ?? this.bio,
      languageKnownList: languageKnownList ?? this.languageKnownList,
      location: location ?? this.location,
      levelBadgeModel: levelBadgeModel ?? this.levelBadgeModel,
      occupation: occupation ?? this.occupation,
      workPlace: workPlace ?? this.workPlace,
      isVerified: isVerified ?? this.isVerified,
      showCompleteProfile: showCompleteProfile ?? this.showCompleteProfile,
      isBlockedByYou: isBlockedByYou ?? this.isBlockedByYou,
      isBlockedByNeighbour: isBlockedByNeighbour ?? this.isBlockedByNeighbour,
    );
  }
}
