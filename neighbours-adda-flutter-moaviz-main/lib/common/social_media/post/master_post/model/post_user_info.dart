import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/connections/models/profile_connection_details.dart';
import 'package:snap_local/profile/profile_level/model/level_badge_model.dart';

class PostUserInfo {
  final String userId;
  final String userName;
  final String userImage;
  final String? userType;
  final String colorCode;
  final bool isVerified;
  final ProfileConnectionDetailsModel? connectionDetailsModel;
  final ComplimentBadgeModel? complimentBadgeModel;
  final LevelBadgeModel? levelBadgeModel;

  PostUserInfo({
    required this.userId,
    required this.userName,
    required this.userImage,
    this.userType,
    required this.colorCode,
    required this.isVerified,

    ///This variable will use to check the viewer connection details with the post owner
    this.connectionDetailsModel,

    ///Badges
    this.complimentBadgeModel,
    this.levelBadgeModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "user_id": userId,
      "name": userName,
      "image": userImage,
      "user_type": userType,
      "color_code": colorCode,
      "connection_details": connectionDetailsModel?.toMap(),
      'is_verified': isVerified,
    };
  }

  factory PostUserInfo.fromMap(Map<String, dynamic> map) {
    return PostUserInfo(
      userId: map["user_id"],
      userName: map["name"],
      userImage: map["image"],
      userType: map["user_type"],
      colorCode: map["color_code"]??"ffffff",
      isVerified: map['is_verified']??false,
      connectionDetailsModel: map["connection_details"] == null
          ? null
          : ProfileConnectionDetailsModel.fromMap(map["connection_details"]),
      complimentBadgeModel: map["compliment_badge"] == null
          ? null
          : ComplimentBadgeSender.fromMap(map["compliment_badge"]),
      levelBadgeModel: map["level_badge"] == null
          ? null
          : LevelBadgeModel.fromMap(map["level_badge"]),
    );
  }
}
