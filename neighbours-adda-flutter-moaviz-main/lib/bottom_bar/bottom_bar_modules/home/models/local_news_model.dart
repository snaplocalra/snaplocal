import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_media_model.dart';

import '../../../../utility/constant/errors.dart';

class LocalNewsModel extends Equatable {
  final String postType;
  final String postFrom;
  final String id;
  final PostUserInfo postUserInfo;
  final Location taggedLocation;
  final Location location;
  final int createdAt;
  final int shareCount;
  final int commentCount;
  final bool isOwnPost;
  final bool isSaved;
  final dynamic userReaction;
  final dynamic reactionDetails;
  final String postPrivacy;
  final bool isSharingAllowed;
  final bool isCommentingAllowed;
  final String postPreferenceRadius;
  final List<PostMediaModel> media;
  final String headline;
  final String description;
  final NewsContributor newsContributor;
  final Category category;
  final ChannelInfo channelInfo;

  const LocalNewsModel({
    required this.postType,
    required this.postFrom,
    required this.id,
    required this.postUserInfo,
    required this.taggedLocation,
    required this.location,
    required this.createdAt,
    required this.shareCount,
    required this.commentCount,
    required this.isOwnPost,
    required this.isSaved,
    required this.userReaction,
    required this.reactionDetails,
    required this.postPrivacy,
    required this.isSharingAllowed,
    required this.isCommentingAllowed,
    required this.postPreferenceRadius,
    required this.media,
    required this.headline,
    required this.description,
    required this.newsContributor,
    required this.category,
    required this.channelInfo,
  });


  factory LocalNewsModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalNews(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalNews(map);
    }
  }

  static LocalNewsModel _buildLocalNews(Map<String, dynamic> map) {
    return LocalNewsModel(
      postType: map['post_type'] ?? '',
      postFrom: map['post_from'] ?? '',
      id: map['id'] ?? '',
      postUserInfo: PostUserInfo.fromMap(map['post_user_info'] ?? {}),
      taggedLocation: Location.fromMap(map['tagged_location'] ?? {}),
      location: Location.fromMap(map['location'] ?? {}),
      createdAt: map['created_at'] ?? 0,
      shareCount: map['share_count'] ?? 0,
      commentCount: map['comment_count'] ?? 0,
      isOwnPost: map['is_own_post'] ?? false,
      isSaved: map['is_saved'] ?? false,
      userReaction: map['user_reaction'],
      reactionDetails: map['reaction_details'],
      postPrivacy: map['post_privacy'] ?? '',
      isSharingAllowed: map['is_sharing_allowed'] ?? false,
      isCommentingAllowed: map['is_commenting_allowed'] ?? false,
      postPreferenceRadius: map['post_preference_radius'] ?? '',
      media: List<PostMediaModel>.from(
        (map['media'] ?? []).map((x) => PostMediaModel.fromMap(x)),
      ),
      headline: map['headline'] ?? '',
      description: map['description'] ?? '',
      newsContributor: NewsContributor.fromMap(map['news_contributor'] ?? {}),
      category: Category.fromMap(map['category'] ?? {}),
      channelInfo: ChannelInfo.fromMap(map['channel_info'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_type': postType,
      'post_from': postFrom,
      'id': id,
      'post_user_info': postUserInfo.toMap(),
      'tagged_location': taggedLocation.toMap(),
      'location': location.toMap(),
      'created_at': createdAt,
      'share_count': shareCount,
      'comment_count': commentCount,
      'is_own_post': isOwnPost,
      'is_saved': isSaved,
      'user_reaction': userReaction,
      'reaction_details': reactionDetails,
      'post_privacy': postPrivacy,
      'is_sharing_allowed': isSharingAllowed,
      'is_commenting_allowed': isCommentingAllowed,
      'post_preference_radius': postPreferenceRadius,
      'media': media.map((x) => x.toMap()).toList(),
      'headline': headline,
      'description': description,
      'news_contributor': newsContributor.toMap(),
      'category': category.toMap(),
      'channel_info': channelInfo.toMap(),
    };
  }

  @override
  List<Object?> get props => [
        postType,
        postFrom,
        id,
        postUserInfo,
        taggedLocation,
        location,
        createdAt,
        shareCount,
        commentCount,
        isOwnPost,
        isSaved,
        userReaction,
        reactionDetails,
        postPrivacy,
        isSharingAllowed,
        isCommentingAllowed,
        postPreferenceRadius,
        media,
        headline,
        description,
        newsContributor,
        category,
        channelInfo,
      ];
}

class PostUserInfo extends Equatable {
  final String userId;
  final String name;
  final String image;
  final ConnectionDetails connectionDetails;
  final LevelBadge levelBadge;
  final dynamic complimentBadge;

  const PostUserInfo({
    required this.userId,
    required this.name,
    required this.image,
    required this.connectionDetails,
    required this.levelBadge,
    this.complimentBadge,
  });

  factory PostUserInfo.fromMap(Map<String, dynamic> map) {
    return PostUserInfo(
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      connectionDetails: ConnectionDetails.fromMap(map['connection_details'] ?? {}),
      levelBadge: LevelBadge.fromMap(map['level_badge'] ?? {}),
      complimentBadge: map['compliment_badge'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'image': image,
      'connection_details': connectionDetails.toMap(),
      'level_badge': levelBadge.toMap(),
      'compliment_badge': complimentBadge,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        image,
        connectionDetails,
        levelBadge,
        complimentBadge,
      ];
}

class ConnectionDetails extends Equatable {
  final String connectionId;
  final bool isConnectionRequestSender;
  final String connectionStatus;

  const ConnectionDetails({
    required this.connectionId,
    required this.isConnectionRequestSender,
    required this.connectionStatus,
  });

  factory ConnectionDetails.fromMap(Map<String, dynamic> map) {
    return ConnectionDetails(
      connectionId: map['connection_id'] ?? '',
      isConnectionRequestSender: map['is_connection_request_sender'] ?? false,
      connectionStatus: map['connection_status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connection_id': connectionId,
      'is_connection_request_sender': isConnectionRequestSender,
      'connection_status': connectionStatus,
    };
  }

  @override
  List<Object?> get props => [
        connectionId,
        isConnectionRequestSender,
        connectionStatus,
      ];
}

class LevelBadge extends Equatable {
  final String image;
  final String points;
  final String type;

  const LevelBadge({
    required this.image,
    required this.points,
    required this.type,
  });

  factory LevelBadge.fromMap(Map<String, dynamic> map) {
    return LevelBadge(
      image: map['image'] ?? '',
      points: map['points'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'points': points,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [image, points, type];
}

class Location extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [address, latitude, longitude];
}

class NewsContributor extends Equatable {
  final String name;
  final bool visibility;

  const NewsContributor({
    required this.name,
    required this.visibility,
  });

  factory NewsContributor.fromMap(Map<String, dynamic> map) {
    return NewsContributor(
      name: map['name'] ?? '',
      visibility: map['visibility'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'visibility': visibility,
    };
  }

  @override
  List<Object?> get props => [name, visibility];
}

class Category extends Equatable {
  final String id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class ChannelInfo extends Equatable {
  final String id;
  final String name;
  final String image;
  final String description;
  final bool isFollowing;

  const ChannelInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.isFollowing,
  });

  factory ChannelInfo.fromMap(Map<String, dynamic> map) {
    return ChannelInfo(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      isFollowing: map['is_following'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'is_following': isFollowing,
    };
  }

  @override
  List<Object?> get props => [id, name, image, description, isFollowing];
} 