part of 'analytics_filter_cubit.dart';

class AnalyticsFilterState extends Equatable {
  final DateTimeRange? dateTimeRange;
  final AnalyticsTimeframeType? timeframe;

  const AnalyticsFilterState({
    this.dateTimeRange,
    this.timeframe,
  });

  @override
  List<Object?> get props => [dateTimeRange, timeframe];

  AnalyticsFilterState copyWith({
    DateTimeRange? dateTimeRange,
    AnalyticsTimeframeType? timeframe,
  }) {
    return AnalyticsFilterState(
      dateTimeRange: dateTimeRange,
      timeframe: timeframe,
    );
  }
}
