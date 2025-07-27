// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'news_posts_cubit.dart';

class NewsPostsState extends Equatable {
  final SocialPostsList news;
  final String? error;
  final bool dataLoading;

  const NewsPostsState({
    required this.news,
    this.error,
    this.dataLoading = false,
  });

  @override
  List<Object?> get props => [news, error, dataLoading];

  NewsPostsState copyWith({
    SocialPostsList? news,
    String? error,
    bool? dataLoading,
  }) {
    return NewsPostsState(
      news: news ?? this.news,
      error: error,
      dataLoading: dataLoading ?? false,
    );
  }
}
