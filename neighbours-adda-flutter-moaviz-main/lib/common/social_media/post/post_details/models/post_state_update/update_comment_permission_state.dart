// Comment permission update
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateCommentPermissionState implements PostStateUpdate {
  final PostCommentPermission newCommentPermission;

  UpdateCommentPermissionState(this.newCommentPermission);

  @override
  void updateState(SocialPostModel socialPostModel) {
    socialPostModel.postCommentPermission = newCommentPermission;
  }
}
