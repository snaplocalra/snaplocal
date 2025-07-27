import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/tools/text_field_regx.dart';

class RegularDataPostModel {
  final String? id;
  final PostType postType;
  final PostCommentPermission commentPermission;
  final PostVisibilityControlEnum visibilityPermission;
  final PostSharePermission sharePermission;
  final String caption;
  final List<NetworkMediaModel> media;
  final double postRadiusPreference;
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng? taggedLocation;

  RegularDataPostModel({
    this.id,
    this.taggedLocation,
    required this.postType,
    required this.caption,
    required this.postRadiusPreference,
    required this.postLocation,
    required this.commentPermission,
    required this.visibilityPermission,
    required this.sharePermission,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_type': postType.param,
      'post_visibility': visibilityPermission.type,
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
      'caption': TextFormatter.removeBlankSpace(caption),
      'post_radius_preference': postRadiusPreference,
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),

      //post location
      'post_location': postLocation.toJson(),
      'tagged_location': taggedLocation?.toJson(),
    };
  }
}
