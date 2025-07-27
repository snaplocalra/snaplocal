//update poll option model
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/poll_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdatePollOptionState implements PostStateUpdate {
  final PollOptionModel newPollOptionModel;

  UpdatePollOptionState(this.newPollOptionModel);

  @override
  void updateState(SocialPostModel socialPostModel) {
    final pollPostModel = socialPostModel as PollPostModel;
    pollPostModel.pollsModel.pollOptionDetails = newPollOptionModel;
  }
}
