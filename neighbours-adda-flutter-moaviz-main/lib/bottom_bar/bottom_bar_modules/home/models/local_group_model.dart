import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalGroupModel extends Equatable {
  final String id;
  final String totalView;
  final String showFollowerList;
  final String createdDate;
  final String groupId;
  final String groupName;
  final String groupImage;
  final String groupDescription;
  final Location location;
  final bool isJoined;
  final bool isGroupAdmin;
  final int followersCount;
  final bool blockedByAdmin;
  final bool blockedByUser;

  const LocalGroupModel({
    required this.id,
    required this.totalView,
    required this.showFollowerList,
    required this.createdDate,
    required this.groupId,
    required this.groupName,
    required this.groupImage,
    required this.groupDescription,
    required this.location,
    required this.isJoined,
    required this.isGroupAdmin,
    required this.followersCount,
    required this.blockedByAdmin,
    required this.blockedByUser,
  });

  factory LocalGroupModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildLocalGroup(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalGroup(json);
    }
  }

  static LocalGroupModel _buildLocalGroup(Map<String, dynamic> json) {
    return LocalGroupModel(
      id: json['id'] as String,
      totalView: json['total_view'] as String,
      showFollowerList: json['show_follower_list'] as String,
      createdDate: json['created_date'] as String,
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
      groupImage: json['group_image'] as String,
      groupDescription: json['group_description'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      isJoined: json['is_joined'] as bool,
      isGroupAdmin: json['is_group_admin'] as bool,
      followersCount: json['followers_count'] as int,
      blockedByAdmin: json['blocked_by_admin'] as bool,
      blockedByUser: json['blocked_by_user'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_view': totalView,
      'show_follower_list': showFollowerList,
      'created_date': createdDate,
      'group_id': groupId,
      'group_name': groupName,
      'group_image': groupImage,
      'group_description': groupDescription,
      'location': location.toJson(),
      'is_joined': isJoined,
      'is_group_admin': isGroupAdmin,
      'followers_count': followersCount,
      'blocked_by_admin': blockedByAdmin,
      'blocked_by_user': blockedByUser,
    };
  }

  @override
  List<Object?> get props => [
        id,
        totalView,
        showFollowerList,
        createdDate,
        groupId,
        groupName,
        groupImage,
        groupDescription,
        location,
        isJoined,
        isGroupAdmin,
        followersCount,
        blockedByAdmin,
        blockedByUser,
      ];
}

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  List<Object?> get props => [latitude, longitude, address];
} 