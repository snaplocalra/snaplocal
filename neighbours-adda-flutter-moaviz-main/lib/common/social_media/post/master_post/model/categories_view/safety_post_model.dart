import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/screen/category_wise_feed_posts_screen.dart';
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

class SafetyPostModel extends SocialPostModel
    implements AllowOwnPostEdit, PostTypeNavigation {
  String title;
  String description;
  SafetyPostModel({
    required this.title,
    required this.description,
    required super.id,
    required super.postUserInfo,
    required super.media,
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
    required super.postType,
    required super.postFrom,
    required super.postSharePermission,
    required super.postCommentPermission,
    required super.postVisibilityPermission,
    required super.groupPageInfo,
  });

  @override
  Map<String, dynamic> toMap() {
    final superToMap = super.toMap();
    superToMap.addAll({'title': title});
    return superToMap;
  }

  factory SafetyPostModel.fromMap(Map<String, dynamic> map) {
    final parentFromJson = SocialPostModel.fromJson(map);
    return SafetyPostModel(
      title: map['title'],
      description: map['description'],
      id: parentFromJson.id,
      media: parentFromJson.media,
      isSaved: parentFromJson.isSaved,
      postLocation: parentFromJson.postLocation,
      taggedlocation: parentFromJson.taggedlocation,
      postUserInfo: parentFromJson.postUserInfo,
      createdAt: parentFromJson.createdAt,
      isOwnPost: parentFromJson.isOwnPost,
      shareCount: parentFromJson.shareCount,
      commentCount: parentFromJson.commentCount,
      reactionEmojiModel: parentFromJson.reactionEmojiModel,
      postPreferenceRadius: parentFromJson.postPreferenceRadius,
      postReactionDetailsModel: parentFromJson.postReactionDetailsModel,
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
  SafetyPostModel copyWith({
    String? title,
    String? description,
    String? id,
    PostUserInfo? postUserInfo,
    bool? isSaved,
    int? shareCount,
    bool? isOwnPost,
    int? commentCount,
    DateTime? createdAt,
    List<NetworkMediaModel>? media,
    double? postPreferenceRadius,
    LocationAddressWithLatLng? postLocation,
    LocationAddressWithLatLng? taggedlocation,
    ReactionEmojiModel? reactionEmojiModel,
    GroupPageInfo? groupPageInfo,
    PostReactionDetailsModel? postReactionDetailsModel,

    //Post settings
    PostType? postType,
    PostFrom? postFrom,
    PostSharePermission? postSharePermission,
    PostCommentPermission? postCommentPermission,
    PostVisibilityControlEnum? postVisibilityPermission,
  }) {
    return SafetyPostModel(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      isSaved: isSaved ?? this.isSaved,
      media: media ?? this.media,
      shareCount: shareCount ?? this.shareCount,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      postLocation: postLocation ?? this.postLocation,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      reactionEmojiModel: reactionEmojiModel ?? this.reactionEmojiModel,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
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
      CategoryWiseFeedPostsScreen.routeName,
      extra: FeedPostCategoryType.safety,
    );
  }

  //search keyword:
  /// Returns true if the search query matches the title and description
  /// If the search query is null, it returns true.
  @override
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return title.toLowerCase().contains(lowerCaseSearchQuery) ||
        description.toLowerCase().contains(lowerCaseSearchQuery);
  }
}
