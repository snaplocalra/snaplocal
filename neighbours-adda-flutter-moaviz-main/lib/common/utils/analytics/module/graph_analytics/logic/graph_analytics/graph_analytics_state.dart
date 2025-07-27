part of 'graph_analytics_cubit.dart';

sealed class GraphAnalyticsState extends Equatable {
  const GraphAnalyticsState();

  @override
  List<Object> get props => [];
}

final class GraphAnalyticsInitial extends GraphAnalyticsState {}

final class GraphAnalyticsLoading extends GraphAnalyticsState {}

final class GraphAnalyticsLoaded extends GraphAnalyticsState {
  final List<GraphAnalyticsModel> data;

  const GraphAnalyticsLoaded({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

final class GraphAnalyticsError extends GraphAnalyticsState {
  final String message;

  const GraphAnalyticsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
