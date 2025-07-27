// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/market_places/models/post_owner_details.dart';
import 'package:snap_local/common/review_module/model/ratings_model.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class EventDetailsModel {
  final String id;
  final String postPreferenceRadius;
  final String title;
  final String description;
  final String shareCount;
  final String topicId;
  final String topicName;
  final PostVisibilityControlEnum postVisibility;
  final bool isSharingAllowed;
  final bool isCommentingAllowed;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endDate;
  final DateTime endTime;
  final int attendingUserCount;
  final bool isAttending;
  final bool isCancelled;
  final bool isClosed;
  final bool isPostAdmin;
  final bool userHasRated;
  final RatingsModel ratingsModel;
  final LocationAddressWithLatLng? taggedlocation;
  final LocationAddressWithLatLng postLocation;
  final String distance;
  final List<NetworkMediaModel> media;
  final bool isSaved;
  final bool reportedByUser;
  final PostOwnerDetailsModel postOwnerDetails;
  final List<EventPostModel> nearByRecommendation;

  EventDetailsModel({
    required this.id,
    required this.postPreferenceRadius,
    required this.title,
    required this.description,
    required this.topicId,
    required this.topicName,
    required this.shareCount,
    required this.postVisibility,
    required this.isSharingAllowed,
    required this.isCommentingAllowed,
    required this.createdAt,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAttending,
    required this.isClosed,
    required this.isCancelled,
    required this.attendingUserCount,
    required this.isPostAdmin,
    required this.postLocation,
    required this.taggedlocation,
    required this.distance,
    required this.media,
    required this.isSaved,
    required this.ratingsModel,
    required this.userHasRated,
    required this.postOwnerDetails,
    required this.nearByRecommendation,
    required this.reportedByUser,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) =>
      EventDetailsModel(
        id: json["id"],
        postPreferenceRadius: json["post_preference_radius"],
        title: json["title"],
        description: json["description"],
        topicId: json['topic_id'],
        topicName: json['topic_name'],
        shareCount: json["share_count"],
        postVisibility:
            PostVisibilityControlEnum.fromString(json["post_visibility"]),
        isSharingAllowed: json["is_sharing_allowed"] == "1",
        isCommentingAllowed: json["is_commenting_allowed"] == "1",
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        startDate: DateTime.fromMillisecondsSinceEpoch(json["start_date"]),
        startTime: DateTime.fromMillisecondsSinceEpoch(
          json["start_time"],
        ),
        endDate: DateTime.fromMillisecondsSinceEpoch(json["end_date"]),
        endTime: DateTime.fromMillisecondsSinceEpoch(
          json["end_time"],
        ),
        isAttending: json["is_attending"],
        isClosed: json["is_closed"],
        isCancelled: json["is_cancelled"],
        attendingUserCount: json["attending_user_count"],
        isPostAdmin: json["is_post_admin"],
        ratingsModel: RatingsModel.fromMap(json["ratings"]),
        postLocation: LocationAddressWithLatLng.fromMap(json["location"]),
        taggedlocation: json["tagged_location"] == null
            ? null
            : LocationAddressWithLatLng.fromMap(json["tagged_location"]),
        distance: json["distance"],
        userHasRated: json["user_has_rated"],
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        nearByRecommendation: List<EventPostModel>.from(
          json["nearby_list"].map((x) => EventPostModel.fromMap(x)),
        ),
        isSaved: json["is_saved"],
        reportedByUser: json["reported_by_user"] ?? false,
        postOwnerDetails: PostOwnerDetailsModel.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_preference_radius": postPreferenceRadius,
        "title": title,
        "description": description,
        'topic_id': topicId,
        'topic_name': topicName,
        "share_count": shareCount,
        "post_visibility": postVisibility.type,
        "is_sharing_allowed": isSharingAllowed,
        "is_commenting_allowed": isCommentingAllowed,
        "created_at": createdAt.millisecondsSinceEpoch,
        'start_date': startDate.millisecondsSinceEpoch,
        'end_date': endDate.millisecondsSinceEpoch,
        'start_time': startTime.millisecondsSinceEpoch,
        'end_time': endTime.millisecondsSinceEpoch,
        "attending_user_count": attendingUserCount,
        "is_attending": isAttending,
        "is_post_admin": isPostAdmin,
        "ratings": ratingsModel.toMap(),
        "is_closed": isClosed,
        "is_cancelled": isCancelled,
        "user_has_rated": userHasRated,
        "location": postLocation.toJson(),
        "tagged_location": taggedlocation?.toJson(),
        "distance": distance,
        "media": List<NetworkMediaModel>.from(media.map((x) => x.toMap())),
        "is_saved": isSaved,
        "user_details": postOwnerDetails.toMap(),
        "reported_by_user": reportedByUser,
      };

  EventDetailsModel copyWith({
    String? id,
    String? postPreferenceRadius,
    String? title,
    String? description,
    String? shareCount,
    String? topicId,
    String? topicName,
    PostVisibilityControlEnum? postVisibility,
    bool? isSharingAllowed,
    bool? isCommentingAllowed,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? startTime,
    DateTime? endDate,
    DateTime? endTime,
    int? attendingUserCount,
    bool? isAttending,
    bool? isCancelled,
    bool? isClosed,
    bool? isPostAdmin,
    bool? userHasRated,
    RatingsModel? ratingsModel,
    LocationAddressWithLatLng? taggedlocation,
    LocationAddressWithLatLng? postLocation,
    String? distance,
    List<NetworkMediaModel>? media,
    bool? isSaved,
    PostOwnerDetailsModel? postOwnerDetails,
    List<EventPostModel>? nearByRecommendation,
    bool? reportedByUser,
  }) {
    return EventDetailsModel(
      id: id ?? this.id,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
      title: title ?? this.title,
      description: description ?? this.description,
      shareCount: shareCount ?? this.shareCount,
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      postVisibility: postVisibility ?? this.postVisibility,
      isSharingAllowed: isSharingAllowed ?? this.isSharingAllowed,
      isCommentingAllowed: isCommentingAllowed ?? this.isCommentingAllowed,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      attendingUserCount: attendingUserCount ?? this.attendingUserCount,
      isAttending: isAttending ?? this.isAttending,
      isCancelled: isCancelled ?? this.isCancelled,
      isClosed: isClosed ?? this.isClosed,
      isPostAdmin: isPostAdmin ?? this.isPostAdmin,
      userHasRated: userHasRated ?? this.userHasRated,
      ratingsModel: ratingsModel ?? this.ratingsModel,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      postLocation: postLocation ?? this.postLocation,
      distance: distance ?? this.distance,
      media: media ?? this.media,
      isSaved: isSaved ?? this.isSaved,
      reportedByUser: reportedByUser ?? this.reportedByUser,
      postOwnerDetails: postOwnerDetails ?? this.postOwnerDetails,
      nearByRecommendation: nearByRecommendation ?? this.nearByRecommendation,
    );
  }
}
