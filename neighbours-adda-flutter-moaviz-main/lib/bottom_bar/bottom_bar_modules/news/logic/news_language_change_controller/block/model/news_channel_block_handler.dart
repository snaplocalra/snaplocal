import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/model/block_handler.dart';

class NewsChannelBlockHandler implements BlockHandler {
  final String channelId;

  NewsChannelBlockHandler(this.channelId);

  @override
  Map<String, dynamic> get data => {"channel_id": channelId};

  @override
  String get apiEndpoint => "channels/channel/toggle_block";
}
