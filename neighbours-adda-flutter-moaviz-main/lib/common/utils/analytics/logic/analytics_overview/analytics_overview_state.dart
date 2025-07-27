part of 'analytics_overview_cubit.dart';

sealed class AnalyticsOverviewState extends Equatable {
  const AnalyticsOverviewState();

  @override
  List<Object> get props => [];
}

final class AnalyticsOverviewInitial extends AnalyticsOverviewState {}

final class AnalyticsOverviewLoading extends AnalyticsOverviewState {}

final class AnalyticsOverviewLoaded extends AnalyticsOverviewState {
  final List<AnalyticsOverviewModel> data;

  const AnalyticsOverviewLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class AnalyticsOverviewError extends AnalyticsOverviewState {
  final String message;

  const AnalyticsOverviewError(this.message);

  @override
  List<Object> get props => [message];
}
