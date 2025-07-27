import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_media_model.dart';

import '../../../../utility/constant/errors.dart';

class LocalEventsResponse extends Equatable {
  final String status;
  final String message;
  final List<LocalEventModel> data;

  const LocalEventsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalEventsResponse.fromMap(Map<String, dynamic> map) {
    return LocalEventsResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<LocalEventModel>.from(
        (map['data'] ?? []).map((x) => LocalEventModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
}

class LocalEventModel extends Equatable {
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
  final EventDetails eventDetails;

  const LocalEventModel({
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
    required this.eventDetails,
  });


  factory LocalEventModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalEvent(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalEvent(map);
    }
  }

  static LocalEventModel _buildLocalEvent(Map<String, dynamic> map) {
    return LocalEventModel(
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
      eventDetails: EventDetails.fromMap(map['event_details'] ?? {}),
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
      'event_details': eventDetails.toMap(),
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
        eventDetails,
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
  List<Object?> get props => [userId, name, image, connectionDetails, levelBadge, complimentBadge];
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
  List<Object?> get props => [connectionId, isConnectionRequestSender, connectionStatus];
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

class EventDetails extends Equatable {
  final String title;
  final String description;
  final String topicId;
  final String topicName;
  final String distance;
  final int startDate;
  final int startTime;
  final int endDate;
  final int endTime;
  final bool isAttending;
  final bool isCancelled;
  final bool isClosed;

  const EventDetails({
    required this.title,
    required this.description,
    required this.topicId,
    required this.topicName,
    required this.distance,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAttending,
    required this.isCancelled,
    required this.isClosed,
  });

  factory EventDetails.fromMap(Map<String, dynamic> map) {
    return EventDetails(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      topicId: map['topic_id'] ?? '',
      topicName: map['topic_name'] ?? '',
      distance: map['distance'] ?? '',
      startDate: map['start_date'] ?? 0,
      startTime: map['start_time'] ?? 0,
      endDate: map['end_date'] ?? 0,
      endTime: map['end_time'] ?? 0,
      isAttending: map['is_attending'] ?? false,
      isCancelled: map['is_cancelled'] ?? false,
      isClosed: map['is_closed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'topic_id': topicId,
      'topic_name': topicName,
      'distance': distance,
      'start_date': startDate,
      'start_time': startTime,
      'end_date': endDate,
      'end_time': endTime,
      'is_attending': isAttending,
      'is_cancelled': isCancelled,
      'is_closed': isClosed,
    };
  }

  @override
  List<Object?> get props => [
        title,
        description,
        topicId,
        topicName,
        distance,
        startDate,
        startTime,
        endDate,
        endTime,
        isAttending,
        isCancelled,
        isClosed,
      ];
} 