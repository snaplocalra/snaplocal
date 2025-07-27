//Share permission update
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateSharePermissionState implements PostStateUpdate {
  final PostSharePermission newSharePermission;

  UpdateSharePermissionState(this.newSharePermission);

  @override
  void updateState(SocialPostModel socialPostModel) {
    socialPostModel.postSharePermission = newSharePermission;
  }
}
