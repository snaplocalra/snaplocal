import 'dart:convert';

import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/news_post_type_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/news_reporter_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class ManageNewsPostModel {
  final String channelId;
  final String newsHeadLine;
  final String newsDescription;
  final NewsReporter newsReporter;
  final bool isGlobalNews;

  //News post Type
  final NewsPostType? newsPostType;

  //news category
  final String categoryId;
  final String otherCategoryName;

  //news media
  final List<NetworkMediaModel> media;

  //news location
  final LocationAddressWithLatLng postLocation;

  ManageNewsPostModel({
    required this.channelId,
    required this.newsHeadLine,
    required this.newsDescription,
    required this.categoryId,
    required this.otherCategoryName,
    required this.newsReporter,
    required this.postLocation,
    required this.isGlobalNews,
    required this.media,
    this.newsPostType,
  });

  //to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'channel_id': channelId,
      'news_headline': newsHeadLine,
      'news_description': newsDescription,
      'category_id': categoryId,
      'other_category_name': otherCategoryName,
      'news_contributor': newsReporter.toJson(),
      'is_global_news': isGlobalNews,
      'post_location': postLocation.toJson(),
      'news_post_type': newsPostType?.name,
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),
    };
  }
}
