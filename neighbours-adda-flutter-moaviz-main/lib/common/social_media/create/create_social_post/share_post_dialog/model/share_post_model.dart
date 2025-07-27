import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/utility/tools/text_field_regx.dart';

class InAppSharePostDataModel {
  final String postId;
  final PostType postType;
  final PostFrom postFrom;
  final PostCommentPermission commentPermission;
  final PostVisibilityControlEnum visibilityPermission;
  final PostSharePermission sharePermission;
  final String caption;

  InAppSharePostDataModel({
    required this.postId,
    required this.postType,
    required this.postFrom,
    required this.caption,
    required this.commentPermission,
    required this.visibilityPermission,
    required this.sharePermission,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'post_type': postType.param,
      'post_from': postFrom.jsonName,
      'caption': TextFormatter.removeBlankSpace(caption),

      //post visibility settings
      'post_visibility': visibilityPermission.type,
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
    };
  }
}
