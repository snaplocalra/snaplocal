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
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class LostFoundPostModel extends SocialPostModel
    implements AllowOwnPostEdit, PostTypeNavigation {
  LostFoundType lostFoundType;
  String title;
  String description;
  LostFoundPostModel({
    required this.lostFoundType,
    required this.title,
    required this.description,
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
    required super.taggedlocation,
    required super.postReactionDetailsModel,
    required super.reactionEmojiModel,
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
    final childToMap = <String, dynamic>{
      'lost_found_status': lostFoundType.name,
      'title': title,
      'description': description,
    };
    superToMap.addAll(childToMap);
    return superToMap;
  }

  factory LostFoundPostModel.fromMap(Map<String, dynamic> json) {
    final parentFromJson = SocialPostModel.fromJson(json);

    return LostFoundPostModel(
      lostFoundType: LostFoundType.fromMap(json['lost_found_status']),
      title: json['title'],
      description: json['description'],
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
  LostFoundPostModel copyWith({
    LostFoundType? lostFoundType,
    List<NetworkMediaModel>? media,
    String? id,
    String? title,
    String? description,
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
    return LostFoundPostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      media: media ?? this.media,
      isSaved: isSaved ?? this.isSaved,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      createdAt: createdAt ?? this.createdAt,
      shareCount: shareCount ?? this.shareCount,
      commentCount: commentCount ?? this.commentCount,
      postLocation: postLocation ?? this.postLocation,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
      lostFoundType: lostFoundType ?? this.lostFoundType,
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
      extra: FeedPostCategoryType.lostFound,
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

enum LostFoundType {
  lost(displayName: LocaleKeys.lost),
  found(displayName: LocaleKeys.found);

  final String displayName;
  const LostFoundType({required this.displayName});

  factory LostFoundType.fromMap(String data) {
    switch (data) {
      case "lost":
        return lost;
      case "found":
        return found;
      default:
        throw ("Invalid lost found type");
    }
  }
}
