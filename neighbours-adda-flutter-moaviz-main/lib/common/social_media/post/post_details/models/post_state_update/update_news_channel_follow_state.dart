import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateNewsChannelFollowState implements PostStateUpdate {
  final bool isFollowed;
  UpdateNewsChannelFollowState({required this.isFollowed});

  @override
  void updateState(SocialPostModel socialPostModel) {
    final newsPost = socialPostModel as NewsPostModel;
    newsPost.newsChannelInfo.isFollowing = isFollowed;
  }
}
