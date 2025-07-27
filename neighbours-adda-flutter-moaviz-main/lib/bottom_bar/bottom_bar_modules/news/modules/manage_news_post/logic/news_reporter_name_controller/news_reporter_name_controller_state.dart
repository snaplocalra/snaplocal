part of 'news_reporter_name_controller_cubit.dart';

class NewsReporterNameControllerState extends Equatable {
  final NewsReporter? newsReporter;

  const NewsReporterNameControllerState({this.newsReporter});

  @override
  List<Object?> get props => [newsReporter];

  NewsReporterNameControllerState copyWith({
    NewsReporter? newsReporter,
  }) {
    return NewsReporterNameControllerState(
      newsReporter: newsReporter ?? this.newsReporter,
    );
  }
}
