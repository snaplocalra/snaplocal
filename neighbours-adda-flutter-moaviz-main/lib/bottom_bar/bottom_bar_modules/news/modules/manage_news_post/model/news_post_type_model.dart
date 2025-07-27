//News post can be state news, national news, international news
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum NewsPostType {
  state(displayText: LocaleKeys.state),
  national(displayText: LocaleKeys.national),
  international(displayText: LocaleKeys.international);

  final String displayText;
  const NewsPostType({required this.displayText});

  //factory method to get the news post type from the string
  static NewsPostType fromString(String newsPostType) {
    switch (newsPostType) {
      case 'state':
        return NewsPostType.state;
      case 'national':
        return NewsPostType.national;
      case 'international':
        return NewsPostType.international;
      default:
        throw Exception('Invalid news post type');
    }
  }
}

class NewsPostTypeModel {
  final NewsPostType newsPostType;
  bool isSelected;

  NewsPostTypeModel({
    required this.newsPostType,
    this.isSelected = false,
  });

  NewsPostTypeModel copyWith({
    NewsPostType? newsPostType,
    bool? isSelected,
  }) {
    return NewsPostTypeModel(
      newsPostType: newsPostType ?? this.newsPostType,
      isSelected: isSelected ?? false,
    );
  }
}

// News post type list
List<NewsPostTypeModel> newsPostTypeList = [
  NewsPostTypeModel(newsPostType: NewsPostType.state),
  NewsPostTypeModel(newsPostType: NewsPostType.national),
  NewsPostTypeModel(newsPostType: NewsPostType.international),
];
