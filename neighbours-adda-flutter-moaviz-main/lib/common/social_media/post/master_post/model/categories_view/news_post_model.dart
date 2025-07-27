import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/news_reporter_model.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
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
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class NewsPostModel extends SocialPostModel implements PostTypeNavigation {
  final String headline;
  final String description;
  final NewsChannelShortInfo newsChannelInfo;
  final double? viewsCount;
  final NewsReporter newsReporter;
  final CategoryModel category;
  NewsPostModel({
    required this.headline,
    required this.newsReporter,
    required this.description,
    required this.newsChannelInfo,
    required this.viewsCount,
    required this.category,
    required super.id,
    required super.postUserInfo,
    required super.postPreferenceRadius,
    required super.postLocation,
    required super.createdAt,
    required super.isOwnPost,
    required super.isSaved,
    required super.shareCount,
    required super.commentCount,
    required super.media,
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
    final childToMap = <String, dynamic>{
      "headline": headline,
      "description": description,
      "views_count": viewsCount,
      "channel_info": newsChannelInfo.toMap(),
      "news_contributor": newsReporter.toMap(),
    };

    superToMap.addAll(childToMap);
    return superToMap;
  }

  factory NewsPostModel.fromMap(Map<String, dynamic> map) {
    final parentFromJson = SocialPostModel.fromJson(map);
    return NewsPostModel(
      headline: map["headline"],
      description: map["description"],
      viewsCount: map["views_count"],
      newsChannelInfo: NewsChannelShortInfo.fromMap(map["channel_info"]),
      newsReporter: NewsReporter.fromMap(map["news_contributor"]),
      category: CategoryModel.fromMap(map["category"]),
      id: parentFromJson.id,
      media: parentFromJson.media,
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
  NewsPostModel copyWith({
    String? id,
    NewsReporter? newsReporter,
    String? headline,
    String? description,
    double? viewsCount,
    String? newsReporterName,
    bool? isSaved,
    int? shareCount,
    bool? isOwnPost,
    int? commentCount,
    DateTime? createdAt,
    List<NetworkMediaModel>? media,
    PostUserInfo? postUserInfo,
    GroupPageInfo? groupPageInfo,
    double? postPreferenceRadius,
    NewsChannelShortInfo? newsChannelInfo,
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
    return NewsPostModel(
      id: id ?? this.id,
      category: category,
      headline: headline ?? this.headline,
      newsReporter: newsReporter ?? this.newsReporter,
      newsChannelInfo: newsChannelInfo ?? this.newsChannelInfo,
      description: description ?? this.description,
      viewsCount: viewsCount ?? this.viewsCount,
      media: media ?? this.media,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      isSaved: isSaved ?? this.isSaved,
      shareCount: shareCount ?? this.shareCount,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      postLocation: postLocation ?? this.postLocation,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
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
    // GoRouter.of(context).pushNamed(NewsListScreen.routeName);
    context.read<BottomBarNavigatorCubit>().changeScreen(selectedIndex: 1);
  }
}

class NewsChannelShortInfo {
  final String id;
  final String name;
  final String image;
  final String description;
  bool isFollowing;

  NewsChannelShortInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.isFollowing,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'is_following': isFollowing,
    };
  }

  factory NewsChannelShortInfo.fromMap(Map<String, dynamic> map) {
    return NewsChannelShortInfo(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      isFollowing: map['is_following'],
    );
  }
}
