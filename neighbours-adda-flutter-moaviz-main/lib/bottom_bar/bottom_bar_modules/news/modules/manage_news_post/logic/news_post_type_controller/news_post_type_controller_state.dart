part of 'news_post_type_controller_cubit.dart';

class NewsPostTypeControllerState extends Equatable {
  final bool isNewsPostTypeLoading;
  final List<NewsPostTypeModel> newsPostTypeList;
  const NewsPostTypeControllerState({
    this.isNewsPostTypeLoading = false,
    required this.newsPostTypeList,
  });
  @override
  List<Object> get props => [isNewsPostTypeLoading, newsPostTypeList];

  NewsPostTypeControllerState copyWith({
    bool? isNewsPostTypeLoading,
    List<NewsPostTypeModel>? newsPostTypeList,
  }) {
    return NewsPostTypeControllerState(
      isNewsPostTypeLoading: isNewsPostTypeLoading ?? false,
      newsPostTypeList: newsPostTypeList ?? this.newsPostTypeList,
    );
  }
}
