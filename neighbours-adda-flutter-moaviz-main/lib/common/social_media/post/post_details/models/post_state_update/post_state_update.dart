import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';

abstract class PostStateUpdate {
  void updateState(SocialPostModel socialPostModel);
}
