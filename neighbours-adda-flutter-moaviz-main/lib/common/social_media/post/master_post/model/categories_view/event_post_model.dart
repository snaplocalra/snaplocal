import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/screens/event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/model/event_short_details_model.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/group_page_info.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_action_permission.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_user_info.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_reaction_details_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class EventPostModel extends SocialPostModel
    implements AllowOwnPostEdit, PostTypeNavigation {
  final EventShortDetailsModel eventShortDetails;
  EventPostModel({
    required this.eventShortDetails,
    required super.id,
    required super.media,
    required super.postUserInfo,
    required super.postPreferenceRadius,
    required super.postLocation,
    required super.createdAt,
    required super.isOwnPost,
    required super.isSaved,
    required super.shareCount,
    required super.commentCount,
    required super.postReactionDetailsModel,
    required super.reactionEmojiModel,
    required super.taggedlocation,
    required super.postFrom,
    required super.postType,
    required super.postSharePermission,
    required super.postCommentPermission,
    required super.postVisibilityPermission,
    required super.groupPageInfo,
  });

  @override
  Map<String, dynamic> toMap() {
    final superToMap = super.toMap();
    final childToMap = <String, dynamic>{
      'event_details': eventShortDetails.toMap()
    };
    superToMap.addAll(childToMap);
    return superToMap;
  }

  factory EventPostModel.fromMap(Map<String, dynamic> json) {
    final parentFromJson = SocialPostModel.fromJson(json);

    return EventPostModel(
      eventShortDetails: EventShortDetailsModel.fromMap(json['event_details']),
      id: parentFromJson.id,
      postUserInfo: parentFromJson.postUserInfo,
      postPreferenceRadius: parentFromJson.postPreferenceRadius,
      postLocation: parentFromJson.postLocation,
      taggedlocation: parentFromJson.taggedlocation,
      createdAt: parentFromJson.createdAt,
      shareCount: parentFromJson.shareCount,
      commentCount: parentFromJson.commentCount,
      isOwnPost: parentFromJson.isOwnPost,
      isSaved: parentFromJson.isSaved,
      reactionEmojiModel: parentFromJson.reactionEmojiModel,
      postReactionDetailsModel: parentFromJson.postReactionDetailsModel,
      media: parentFromJson.media,
      groupPageInfo: parentFromJson.groupPageInfo,
      //Post settings
      postType: parentFromJson.postType,
      postFrom: parentFromJson.postFrom,
      postSharePermission: parentFromJson.postSharePermission,
      postCommentPermission: parentFromJson.postCommentPermission,
      postVisibilityPermission: parentFromJson.postVisibilityPermission,
    );
  }

  @override
  EventPostModel copyWith({
    EventShortDetailsModel? eventShortDetails,
    List<NetworkMediaModel>? media,
    String? id,
    PostUserInfo? postUserInfo,
    bool? isSaved,
    int? shareCount,
    bool? isOwnPost,
    int? commentCount,
    DateTime? createdAt,
    double? postPreferenceRadius,
    GroupPageInfo? groupPageInfo,
    LocationAddressWithLatLng? postLocation,
    LocationAddressWithLatLng? taggedlocation,
    ReactionEmojiModel? reactionEmojiModel,
    PostReactionDetailsModel? postReactionDetailsModel,
    //Post settings
    PostType? postType,
    PostFrom? postFrom,
    PostSharePermission? postSharePermission,
    PostCommentPermission? postCommentPermission,
    PostVisibilityControlEnum? postVisibilityPermission,
  }) {
    return EventPostModel(
      eventShortDetails: eventShortDetails ?? this.eventShortDetails,
      media: media ?? this.media,
      id: id ?? this.id,
      isSaved: isSaved ?? this.isSaved,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      createdAt: createdAt ?? this.createdAt,
      shareCount: shareCount ?? this.shareCount,
      commentCount: commentCount ?? this.commentCount,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
      postLocation: postLocation ?? this.postLocation,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      reactionEmojiModel: reactionEmojiModel ?? this.reactionEmojiModel,
      postReactionDetailsModel:
          postReactionDetailsModel ?? this.postReactionDetailsModel,

      //Post settings
      postType: postType ?? this.postType,
      postFrom: postFrom ?? this.postFrom,
      postSharePermission: postSharePermission ?? this.postSharePermission,
      postCommentPermission:
          postCommentPermission ?? this.postCommentPermission,
      postVisibilityPermission:
          postVisibilityPermission ?? this.postVisibilityPermission,
    );
  }

  @override
  void navigateToPostTypeModule(BuildContext context) {
    GoRouter.of(context).pushNamed(
      EventScreen.routeName,
      extra: EventPostListType.localEvents,
    );
  }

  /// Returns true if the search query matches the event title, description and category.
  @override
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return eventShortDetails.title
            .toLowerCase()
            .contains(lowerCaseSearchQuery) ||
        eventShortDetails.description
            .toLowerCase()
            .contains(lowerCaseSearchQuery) ||
        eventShortDetails.eventCategoryName
            .toLowerCase()
            .contains(lowerCaseSearchQuery);
  }
}
