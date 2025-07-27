//Save status update
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateSaveStatusState implements PostStateUpdate {
  final bool newSaveStatus;

  UpdateSaveStatusState(this.newSaveStatus);

  @override
  void updateState(SocialPostModel socialPostModel) {
    socialPostModel.isSaved = newSaveStatus;
  }
}
