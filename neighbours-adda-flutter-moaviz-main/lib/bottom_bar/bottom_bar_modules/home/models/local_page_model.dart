import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalPageModel extends Equatable {
  final String id;
  final String totalView;
  final String enableChat;
  final String enableFollower;
  final String createdDate;
  final String pageId;
  final String pageName;
  final String pageImage;
  final String pageDescription;
  final bool isFollowing;
  final bool isPageAdmin;
  final Location location;
  final int followersCount;
  final bool blockedByAdmin;
  final bool blockedByUser;

  const LocalPageModel({
    required this.id,
    required this.totalView,
    required this.enableChat,
    required this.enableFollower,
    required this.createdDate,
    required this.pageId,
    required this.pageName,
    required this.pageImage,
    required this.pageDescription,
    required this.isFollowing,
    required this.isPageAdmin,
    required this.location,
    required this.followersCount,
    required this.blockedByAdmin,
    required this.blockedByUser,
  });


  factory LocalPageModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildLocalPage(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalPage(json);
    }
  }

  static LocalPageModel _buildLocalPage(Map<String, dynamic> json) {
    return LocalPageModel(
      id: json['id'] as String,
      totalView: json['total_view'] as String,
      enableChat: json['enable_chat'] as String,
      enableFollower: json['enable_follower'] as String,
      createdDate: json['created_date'] as String,
      pageId: json['page_id'] as String,
      pageName: json['page_name'] as String,
      pageImage: json['page_image'] as String,
      pageDescription: json['page_description'] as String,
      isFollowing: json['is_following'] as bool,
      isPageAdmin: json['is_page_admin'] as bool,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      followersCount: json['followers_count'] as int,
      blockedByAdmin: json['blocked_by_admin'] as bool,
      blockedByUser: json['blocked_by_user'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_view': totalView,
      'enable_chat': enableChat,
      'enable_follower': enableFollower,
      'created_date': createdDate,
      'page_id': pageId,
      'page_name': pageName,
      'page_image': pageImage,
      'page_description': pageDescription,
      'is_following': isFollowing,
      'is_page_admin': isPageAdmin,
      'location': location.toJson(),
      'followers_count': followersCount,
      'blocked_by_admin': blockedByAdmin,
      'blocked_by_user': blockedByUser,
    };
  }

  @override
  List<Object?> get props => [
        id,
        totalView,
        enableChat,
        enableFollower,
        createdDate,
        pageId,
        pageName,
        pageImage,
        pageDescription,
        isFollowing,
        isPageAdmin,
        location,
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