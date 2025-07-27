import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/extension_functions/string_converter.dart';

class ManageGroupPostModel {
  final String? id;
  final String caption;
  final String groupId;
  final PostType postType;
  final PostCommentPermission commentPermission;
  final PostSharePermission sharePermission;
  final LocationAddressWithLatLng? taggedLocation;
  final List<NetworkMediaModel> media;

  ManageGroupPostModel({
    required this.id,
    required this.caption,
    required this.groupId,
    required this.postType,
    required this.commentPermission,
    required this.sharePermission,
    this.taggedLocation,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'group_id': groupId,
      'post_type': postType.param,
      'caption': caption.removeBlankSpace(),
      'tagged_location': taggedLocation?.toJson(),
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),
    };
  }
}
