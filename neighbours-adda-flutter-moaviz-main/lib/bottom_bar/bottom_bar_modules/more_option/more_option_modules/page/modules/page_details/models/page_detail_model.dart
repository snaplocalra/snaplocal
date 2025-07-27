import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import '../../../../../../../../utility/constant/errors.dart';

class PageDetailsModel extends Equatable {
  final ConnectionDetailsModel pageConnectionDetailsModel;
  final PageProfileDetailsModel pageProfileDetailsModel;
  final SocialPostsList pagePosts;

  const PageDetailsModel({
    required this.pageConnectionDetailsModel,
    required this.pageProfileDetailsModel,
    required this.pagePosts,
  });

  factory PageDetailsModel.fromJson(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildPageDetails(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildPageDetails(map);
    }
  }

  static PageDetailsModel _buildPageDetails(Map<String, dynamic> map) {
    return PageDetailsModel(
      pageConnectionDetailsModel: ConnectionDetailsModel.fromMap(
        map['connection_details'] as Map<String, dynamic>,
      ),
      pageProfileDetailsModel: PageProfileDetailsModel.fromJson(
        map['page_profile_data'] as Map<String, dynamic>,
      ),
      pagePosts: SocialPostsList.fromMap(
        map['page_post'] as Map<String, dynamic>,
      ),
    );
  }

  PageDetailsModel copyWith({
    ConnectionDetailsModel? pageConnectionDetailsModel,
    PageProfileDetailsModel? pageProfileDetailsModel,
    SocialPostsList? pagePosts,
  }) {
    return PageDetailsModel(
      pageConnectionDetailsModel:
      pageConnectionDetailsModel ?? this.pageConnectionDetailsModel,
      pageProfileDetailsModel:
      pageProfileDetailsModel ?? this.pageProfileDetailsModel,
      pagePosts: pagePosts ?? this.pagePosts,
    );
  }

  @override
  List<Object?> get props =>
      [pageConnectionDetailsModel, pageProfileDetailsModel, pagePosts];
}

class ConnectionDetailsModel {
  final String? connectionId;
  final ConnectionStatus connectionStatus;

  ConnectionDetailsModel({
    this.connectionId,
    required this.connectionStatus,
  });

  factory ConnectionDetailsModel.fromMap(Map<String, dynamic> map) {
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

  static ConnectionDetailsModel _buildConnection(Map<String, dynamic> map) {
    return ConnectionDetailsModel(
      connectionId:
      map['connection_id'] != null ? map['connection_id'] as String : null,
      connectionStatus: ConnectionStatus.fromString(map['connection_status']),
    );
  }
}

class PageProfileDetailsModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String coverImage;
  final int totalFollowers;
  final bool isPageAdmin;
  final int pagePreferenceRadius;
  final double latitude;
  final double longitude;
  final String address;
  final bool enableChat;
  final bool showFollower;
  final bool blockedByAdmin;
  final bool blockedByUser;
  final CategoryListModelV2 category;
  bool isFavorite;
  bool isVerified;

  PageProfileDetailsModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.totalFollowers,
    required this.isPageAdmin,
    required this.pagePreferenceRadius,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.enableChat,
    required this.showFollower,
    required this.blockedByAdmin,
    required this.blockedByUser,
    required this.category,
    required this.isFavorite,
    required this.isVerified,
  });

  factory PageProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildProfile(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildProfile(json);
    }
  }

  static PageProfileDetailsModel _buildProfile(Map<String, dynamic> json) {
    return PageProfileDetailsModel(
      id: json["id"],
      name: json["name"],
      userId: json["user_id"],
      category: CategoryListModelV2.fromMap(json["category"]),
      description: json["description"] ?? "",
      coverImage: json["cover_image"],
      totalFollowers: json["total_followers"] ?? 0,
      isPageAdmin: json["is_page_admin"],
      pagePreferenceRadius: json["page_preference_radius"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      address: json["address"],
      enableChat: json["enable_chat"],
      showFollower: json["show_follower"],
      blockedByAdmin: json["blocked_by_admin"],
      blockedByUser: json["blocked_by_user"],
      isFavorite: json["is_favorite"] ?? false,
      isVerified: json["is_verified"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "description": description,
    "cover_image": coverImage,
    "total_followers": totalFollowers,
    "page_category": category,
    "is_page_admin": isPageAdmin,
    "page_preference_radius": pagePreferenceRadius,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "enable_chat": enableChat,
    "show_follower": showFollower,
    "blocked_by_admin": blockedByAdmin,
    "blocked_by_user": blockedByUser,
    "category": category.data.map((e) => e.toMap()).toList(),
    "is_favorite": isFavorite,
    "is_verified": isVerified,
  };
}
