//update comment count
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/comment_update_strategy.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateCommentCountState implements PostStateUpdate {
  final CommentUpdateStrategy commentUpdateStrategy;

  UpdateCommentCountState(this.commentUpdateStrategy);

  @override
  void updateState(SocialPostModel socialPostModel) {
    //Update the object and it will reflect in the post list array
    socialPostModel.commentCount =
        commentUpdateStrategy.updateCommentCount(socialPostModel.commentCount);
  }
}
