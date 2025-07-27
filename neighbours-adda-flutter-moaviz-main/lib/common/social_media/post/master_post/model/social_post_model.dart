// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/official_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/regular_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/safety_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/shared_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/group_page_info.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_index_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_user_info.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_reaction_details_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

import '../../../../../utility/constant/errors.dart';

class SocialPostsList {
  List<SocialPostModel> socialPostList;
  PaginationModel paginationModel;
  List<PostIndexModel> postIndexList;

  SocialPostsList({
    this.socialPostList = const [],
    required this.paginationModel,
    this.postIndexList = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': socialPostList.map((x) => x.toMap()).toList(),
      'post_index_list': postIndexList.map((x) => x.toMap()).toList(),
    };
  }

  factory SocialPostsList.emptyModel() => SocialPostsList(
        socialPostList: [],
        paginationModel: PaginationModel.initial(),
        postIndexList: [],
      );

  // factory SocialPostsList.fromMap(Map<String, dynamic> map) {
  //   return SocialPostsList(
  //     socialPostList: List<SocialPostModel>.from(
  //       (map['data']).map<SocialPostModel>(
  //         (x) => SocialPostModel.getModelByType(x),
  //       ),
  //     ),
  //     paginationModel: PaginationModel.fromMap(map),
  //     postIndexList: List<PostIndexModel>.from(
  //       (map['post_index'] ?? []).map<PostIndexModel>(
  //         (x) => PostIndexModel.fromMap(x),
  //       ),
  //     ),
  //   );
  // }

  factory SocialPostsList.fromMap(Map<String, dynamic> map) {
    try {
      return SocialPostsList(
        socialPostList: List<SocialPostModel>.from(
          (map['data'] as List).map((x) {
            if (isDebug) {
              try {
                return SocialPostModel.getModelByType(x);
              } on TypeError {
                throw ErrorConstants.nullPointer;
              } catch (_) {
                throw ErrorConstants.nullPointer;
              }
            } else {
              return SocialPostModel.getModelByType(x);
            }
          }),
        ),
        paginationModel: PaginationModel.fromMap(map),
        postIndexList: List<PostIndexModel>.from(
          (map['post_index'] ?? []).map((x) {
            if (isDebug) {
              try {
                return PostIndexModel.fromMap(x);
              } on TypeError {
                throw ErrorConstants.nullPointer;
              } catch (_) {
                throw ErrorConstants.nullPointer;
              }
            } else {
              return PostIndexModel.fromMap(x);
            }
          }),
        ),
      );
    } on TypeError {
      if (isDebug) {
        throw ErrorConstants.nullPointer;
      }
      rethrow;
    } catch (_) {
      if (isDebug) {
        throw ErrorConstants.nullPointer;
      }
      rethrow;
    }
  }


  String toJson() => json.encode(toMap());

  //Use for pagination
  SocialPostsList paginationCopyWith({required SocialPostsList newData}) {
    socialPostList.addAll(newData.socialPostList);
    paginationModel = newData.paginationModel;
    postIndexList = newData.postIndexList;

    return SocialPostsList(
      socialPostList: socialPostList,
      paginationModel: paginationModel,
      postIndexList: postIndexList,
    );
  }
}

class SocialPostModel {
  //Post type
  final PostType postType;
  final PostFrom postFrom;

  //Post contents
  final String id;
  bool isSaved;
  final int shareCount;
  final String? caption;
  final bool isOwnPost;
  int commentCount;
  final DateTime createdAt;
  final double postPreferenceRadius;
  LocationAddressWithLatLng? taggedlocation;
  final LocationAddressWithLatLng postLocation;
  List<NetworkMediaModel> media;
  final PostUserInfo postUserInfo;
  ReactionEmojiModel? reactionEmojiModel;
  PostReactionDetailsModel? postReactionDetailsModel;

  //Group Page Post
  final GroupPageInfo? groupPageInfo;

  //Post permission settings
  PostSharePermission postSharePermission;
  PostCommentPermission postCommentPermission;
  final PostVisibilityControlEnum postVisibilityPermission;

  SocialPostModel({
    //Post type
    required this.postType,
    required this.postFrom,

    //Post contents
    required this.id,
    required this.postPreferenceRadius,
    required this.postLocation,
    required this.createdAt,
    required this.isOwnPost,
    required this.isSaved,
    required this.shareCount,
    this.caption,
    required this.commentCount,
    required this.media,
    required this.postUserInfo,
    required this.groupPageInfo,
    required this.taggedlocation,
    required this.reactionEmojiModel,
    required this.postReactionDetailsModel,

    //Post permission settings
    required this.postSharePermission,
    required this.postCommentPermission,
    required this.postVisibilityPermission,
  });


  factory SocialPostModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildFromJson(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildFromJson(json);
    }
  }

  static SocialPostModel _buildFromJson(Map<String, dynamic> json) {
    final reactionEmojiModel = json["user_reaction"] == null
        ? null
        : ReactionEmojiModel.fromMap(json["user_reaction"]);

    final groupPagePost = json["group_page_info"] == null
        ? null
        : GroupPageInfo.fromMap(json["group_page_info"]);

    return SocialPostModel(
      id: json["id"],
      postType: PostType.fromString(json["post_type"]),
      postFrom: PostFrom.fromString(json["post_from"]),
      postUserInfo: PostUserInfo.fromMap(json["post_user_info"]),
      groupPageInfo: groupPagePost,
      postSharePermission:
      PostSharePermission.fromBool(json["is_sharing_allowed"]),
      postCommentPermission:
      PostCommentPermission.fromBool(json["is_commenting_allowed"]),
      postVisibilityPermission:
      PostVisibilityControlEnum.fromString(json["post_privacy"]),
      media: List<NetworkMediaModel>.from((json['media'] ?? [])
          .map((x) => NetworkMediaModel.fromMap(x))),
      postPreferenceRadius:
      double.tryParse(json['post_preference_radius'].toString()) ?? 0,
      taggedlocation: json['tagged_location'] == null
          ? null
          : LocationAddressWithLatLng.fromMap(json['tagged_location']),
      postLocation: LocationAddressWithLatLng.fromMap(json['location']),
      createdAt:
      DateTime.fromMillisecondsSinceEpoch((json["created_at"] as int)),
      shareCount: json["share_count"] ?? 0,
      caption: json["caption"] ?? "",
      commentCount: json["comment_count"] ?? 0,
      isOwnPost: json["is_own_post"] ?? false,
      isSaved: json["is_saved"],
      reactionEmojiModel: reactionEmojiModel,
      postReactionDetailsModel: json["reaction_details"] == null
          ? null
          : PostReactionDetailsModel.fromMap(
        map: json["reaction_details"],
        ownReactionEmojiModel: reactionEmojiModel,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "post_type": postType.param,
        "post_from": postFrom.jsonName,
        "post_user_info": postUserInfo.toMap(),
        "is_sharing_allowed": postSharePermission.toBool(),
        "is_commenting_allowed": postCommentPermission.toBool(),
        "post_privacy": postVisibilityPermission.type,
        "media": media.map((x) => x.toMap()).toList(),
        "post_preference_radius": postPreferenceRadius,
        "tagged_location": taggedlocation?.toMap(),
        "location": postLocation.toMap(), // Updated key
        "created_at": createdAt.millisecondsSinceEpoch,
        "share_count": shareCount,
        "comment_count": commentCount,
        "is_own_post": isOwnPost,
        "is_saved": isSaved,
        "user_reaction": reactionEmojiModel?.toMap(),
        "reaction_details": postReactionDetailsModel?.toMap(),
        "group_page_info": groupPageInfo?.toMap(),
      };


  factory SocialPostModel.getModelByType(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildTypedModel(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildTypedModel(json);
    }
  }

  static SocialPostModel _buildTypedModel(Map<String, dynamic> json) {
    final postType = PostType.fromString(json['post_type']);
    switch (postType) {
      case PostType.general:
      case PostType.askQuestion:
      case PostType.askSuggestion:
        return RegularPostModel.fromMap(json);
      case PostType.safety:
        return SafetyPostModel.fromMap(json);
      case PostType.lostFound:
        return LostFoundPostModel.fromMap(json);
      case PostType.event:
        return EventPostModel.fromMap(json);
      case PostType.poll:
        return PollPostModel.fromMap(json);
      case PostType.newsPost:
        return NewsPostModel.fromMap(json);
      case PostType.sharedPost:
        return SharedPostModel.fromMap(json);
      default:
        throw Exception("Unknown post type: $postType");
    }
  }


  SocialPostModel copyWith({
    String? id,
    bool? isSaved,
    int? shareCount,
    bool? isOwnPost,
    int? commentCount,
    DateTime? createdAt,
    double? postPreferenceRadius,
    LocationAddressWithLatLng? taggedlocation,
    LocationAddressWithLatLng? postLocation,
    List<NetworkMediaModel>? media,
    PostUserInfo? postUserInfo,
    GroupPageInfo? groupPageInfo,
    PostSharePermission? postSharePermission,
    PostCommentPermission? postCommentPermission,
    PostVisibilityControlEnum? postVisibilityPermission,
    PostType? postType,
    PostFrom? postFrom,
    ReactionEmojiModel? reactionEmojiModel,
    PostReactionDetailsModel? postReactionDetailsModel,
  }) {
    return SocialPostModel(
      id: id ?? this.id,
      isSaved: isSaved ?? this.isSaved,
      shareCount: shareCount ?? this.shareCount,
      caption: caption??"",
      isOwnPost: isOwnPost ?? this.isOwnPost,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      postPreferenceRadius: postPreferenceRadius ?? this.postPreferenceRadius,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      postLocation: postLocation ?? this.postLocation,
      media: media ?? this.media,
      postUserInfo: postUserInfo ?? this.postUserInfo,
      groupPageInfo: groupPageInfo ?? this.groupPageInfo,
      postSharePermission: postSharePermission ?? this.postSharePermission,
      postCommentPermission:
          postCommentPermission ?? this.postCommentPermission,
      postVisibilityPermission:
          postVisibilityPermission ?? this.postVisibilityPermission,
      postType: postType ?? this.postType,
      postFrom: postFrom ?? this.postFrom,
      reactionEmojiModel: reactionEmojiModel ?? this.reactionEmojiModel,
      postReactionDetailsModel:
          postReactionDetailsModel ?? this.postReactionDetailsModel,
    );
  }

  //search keyword contract, need to implement in safety, lost found, event
  bool searchKeyword(String? searchQuery) {
    return true;
  }
}


