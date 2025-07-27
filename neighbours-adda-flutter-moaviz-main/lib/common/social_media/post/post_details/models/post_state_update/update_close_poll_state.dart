//update close poll state
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateClosePollState implements PostStateUpdate {
  final bool newClosePollStatus;

  UpdateClosePollState(this.newClosePollStatus);

  @override
  void updateState(SocialPostModel socialPostModel) {
    final pollDetails = socialPostModel as PollPostModel;
    pollDetails.pollsModel.disablePoll = newClosePollStatus;
  }
}
