import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/model/follow_handler.dart';

class NewsChannelFollowHandler implements FollowHandler {
  final String channelId;

  NewsChannelFollowHandler(this.channelId);

  @override
  Map<String, dynamic> get data => {"channel_id": channelId};

  @override
  String get apiEndpoint => "channels/channel/toggleFollow";
}
