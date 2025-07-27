part of 'news_earnings_cubit.dart';

sealed class NewsEarningsState extends Equatable {
  const NewsEarningsState();

  @override
  List<Object> get props => [];
}

final class NewsEarningsInitial extends NewsEarningsState {}

final class NewsEarningsLoading extends NewsEarningsState {}

//data loaded
final class NewsEarningsLoaded extends NewsEarningsState {
  final NewsEarningsDetailsModel newsEarningsDetailsModel;

  const NewsEarningsLoaded({required this.newsEarningsDetailsModel});

  @override
  List<Object> get props => [newsEarningsDetailsModel];
}

//error
final class NewsEarningsLoadFailed extends NewsEarningsState {
  final String errorMessage;

  const NewsEarningsLoadFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
