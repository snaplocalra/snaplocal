import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_privacy_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

import '../../../../../../utility/constant/errors.dart';

class GroupDetailsModel {
  final GroupConnectionDetailsModel groupConnectionDetailsModel;
  final GroupProfileDetailsModel groupProfileDetailsModel;
  final SocialPostsList groupPosts;

  GroupDetailsModel({
    required this.groupConnectionDetailsModel,
    required this.groupProfileDetailsModel,
    required this.groupPosts,
  });

  factory GroupDetailsModel.fromJson(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildGroupDetails(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildGroupDetails(map);
    }
  }

  static GroupDetailsModel _buildGroupDetails(Map<String, dynamic> map) {
    return GroupDetailsModel(
      groupConnectionDetailsModel: GroupConnectionDetailsModel.fromMap(
          map['connection_details'] as Map<String, dynamic>),
      groupProfileDetailsModel: GroupProfileDetailsModel.fromJson(
          map['group_profile_data'] as Map<String, dynamic>),
      groupPosts:
          SocialPostsList.fromMap(map['group_post'] as Map<String, dynamic>),
    );
  }

  GroupDetailsModel copyWith({
    GroupConnectionDetailsModel? groupConnectionDetailsModel,
    GroupProfileDetailsModel? groupProfileDetailsModel,
    SocialPostsList? groupPosts,
  }) {
    return GroupDetailsModel(
      groupConnectionDetailsModel:
          groupConnectionDetailsModel ?? this.groupConnectionDetailsModel,
      groupProfileDetailsModel:
          groupProfileDetailsModel ?? this.groupProfileDetailsModel,
      groupPosts: groupPosts ?? this.groupPosts,
    );
  }
}

class GroupConnectionDetailsModel {
  final String? connectionId;
  final ConnectionStatus connectionStatus;
  GroupConnectionDetailsModel({
    this.connectionId,
    required this.connectionStatus,
  });


  factory GroupConnectionDetailsModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildConnection(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildConnection(map);
    }
  }

  static GroupConnectionDetailsModel _buildConnection(Map<String, dynamic> map) {
    return GroupConnectionDetailsModel(
      connectionId:
          map['connection_id'] != null ? map['connection_id'] as String : null,
      connectionStatus: ConnectionStatus.fromString(map['connection_status']),
    );
  }
}

class GroupProfileDetailsModel {
  final String id;
  final String userId;
  final CategoryListModelV2 category;
  final String name;
  final String description;
  final String coverImage;
  final int totalMembers;
  final GroupPrivacyStatus groupPrivacyType;
  final bool isGroupAdmin;
  final int groupPreferenceRadius;
  final double latitude;
  final double longitude;
  final String address;
  final bool blockedByUser;
  final bool blockedByAdmin;
  final bool showFollower;
  bool isFavorite;
  bool? enableFollower;
  final bool isVerified;


  GroupProfileDetailsModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.groupPrivacyType,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.totalMembers,
    required this.isGroupAdmin,
    required this.groupPreferenceRadius,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.blockedByUser,
    required this.blockedByAdmin,
    required this.showFollower,
    required this.isFavorite,
    this.enableFollower,
    required this.isVerified,
  });


  factory GroupProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildGroupProfile(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildGroupProfile(json);
    }
  }

  static GroupProfileDetailsModel _buildGroupProfile(Map<String, dynamic> json) =>
      GroupProfileDetailsModel(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        category: CategoryListModelV2.fromMap(json["category"]),
        description: json["description"] ?? "",
        coverImage: json["cover_image"],
        totalMembers: json["total_members"],
        groupPrivacyType: GroupPrivacyStatus.fromString(json["privacy_type"]),
        isGroupAdmin: json["is_group_admin"],
        groupPreferenceRadius: json["group_preference_radius"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        blockedByUser: json["blocked_by_user"],
        blockedByAdmin: json["blocked_by_admin"],
        showFollower: json["show_follower"] ?? false,
        isFavorite: json["is_favorite"] ?? false,
        isVerified: json["is_verified"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category": category.data.map((e) => e.toMap()).toList(),
        "name": name,
        "description": description,
        "cover_image": coverImage,
        "total_members": totalMembers,
        "group_privacy_type": groupPrivacyType,
        "is_group_admin": isGroupAdmin,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "group_preference_radius": groupPreferenceRadius,
        "blocked_by_user": blockedByUser,
        "blocked_by_admin": blockedByAdmin,
        "enable_follower": enableFollower,
        "show_follower": showFollower,
        "is_favorite": isFavorite,
        "is_verified": isVerified,
      };
}
