part of 'news_dashboard_statistics_cubit.dart';

sealed class NewsDashboardStatisticsState extends Equatable {
  const NewsDashboardStatisticsState();

  @override
  List<Object> get props => [];
}

final class NewsDashboardInitial extends NewsDashboardStatisticsState {}

final class NewsDashboardLoading extends NewsDashboardStatisticsState {}

final class NewsDashboardLoaded extends NewsDashboardStatisticsState {
  final NewsDashboardChannelStatisticsModel newsDashboardChannelStatistics;
  const NewsDashboardLoaded(this.newsDashboardChannelStatistics);
  @override
  List<Object> get props => [newsDashboardChannelStatistics];
}

final class NewsDashboardLoadFailed extends NewsDashboardStatisticsState {
  final String errorMessage;

  const NewsDashboardLoadFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
