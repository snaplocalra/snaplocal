import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/manage_news_post_model.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';

class PostNewsPreviewScreenPayload {
  final ManageNewsPostModel newsPostModel;
  final List<MediaFileModel> pickedMediaList;

  PostNewsPreviewScreenPayload({
    required this.newsPostModel,
    required this.pickedMediaList,
  });
}
