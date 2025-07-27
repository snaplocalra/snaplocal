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

class SharedPostModel extends SocialPostModel implements AllowOwnPostEdit {
  final SocialPostModel sharedPost;
  final String caption;
  SharedPostModel({
    required this.sharedPost,
    required this.caption,
    required super.id,
    required super.postUserInfo,
    required super.postPreferenceRadius,
    required super.postLocation,
    required super.media,
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
    superToMap.addAll({"shared_post": sharedPost.toMap()});
    return superToMap;
  }

  factory SharedPostModel.fromMap(Map<String, dynamic> map) {
    final parentFromJson = SocialPostModel.fromJson(map);
    final sharedPost = SocialPostModel.getModelByType(map['shared_post']);

    return SharedPostModel(
      sharedPost: sharedPost,
      caption: map['caption'],
      id: parentFromJson.id,
      postUserInfo: parentFromJson.postUserInfo,
      media: parentFromJson.media,
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
  SharedPostModel copyWith({
    //Shared post
    SocialPostModel? sharedPost,
    String? caption,
    String? id,
    PostUserInfo? postUserInfo,
    bool? isSaved,
    int? shareCount,
    bool? isOwnPost,
    int? commentCount,
    DateTime? createdAt,
    double? postPreferenceRadius,
    List<NetworkMediaModel>? media,
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
    return SharedPostModel(
      //Shared post
      sharedPost: sharedPost ?? this.sharedPost,
      caption: caption ?? this.caption,
      id: id ?? this.id,
      media: media ?? this.media,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      isSaved: isSaved ?? this.isSaved,
      shareCount: shareCount ?? this.shareCount,
      isOwnPost: isOwnPost ?? this.isOwnPost,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
      postLocation: postLocation ?? this.postLocation,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
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
}
