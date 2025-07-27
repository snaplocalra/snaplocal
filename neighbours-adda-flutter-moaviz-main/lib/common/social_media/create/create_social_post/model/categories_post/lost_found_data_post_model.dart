import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/tools/text_field_regx.dart';

class LostFoundDataPostModel {
  final String? id;
  final String title;
  final PostType postType;
  final LostFoundType lostFoundType;
  final PostCommentPermission commentPermission;
  final PostVisibilityControlEnum visibilityPermission;
  final PostSharePermission sharePermission;
  final String description;
  final List<NetworkMediaModel> media;

  final double postRadiusPreference;
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng? incidentLocation;

  LostFoundDataPostModel({
    this.incidentLocation,
    this.id,
    required this.title,
    required this.postType,
    required this.lostFoundType,
    required this.description,
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
      'title': title,
      'post_type': postType.param,
      'lost_or_found': lostFoundType.name,
      'post_visibility': visibilityPermission.type,
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
      'description': TextFormatter.removeBlankSpace(description),
      'post_radius_preference': postRadiusPreference,
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),

      //post location
      'post_location': postLocation.toJson(),
      'tagged_location': incidentLocation?.toJson(),
    };
  }
}
