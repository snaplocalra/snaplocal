part of 'news_post_details_cubit.dart';

sealed class NewsPostDetailsState extends Equatable {
  const NewsPostDetailsState();

  @override
  List<Object> get props => [];
}

final class NewsPostDetailsInitial extends NewsPostDetailsState {}

final class NewsPostDetailsLoading extends NewsPostDetailsState {}

final class NewsPostDetailsLoaded extends NewsPostDetailsState {
  final NewsPostModel newsPost;
  const NewsPostDetailsLoaded(this.newsPost);
  @override
  List<Object> get props => [newsPost];
}

final class NewsPostDetailsError extends NewsPostDetailsState {
  final String message;
  const NewsPostDetailsError(this.message);
  @override
  List<Object> get props => [message];
}
