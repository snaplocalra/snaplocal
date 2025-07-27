part of 'news_dashboard_statistics_filter_controller_cubit.dart';

class NewsDashboardStatisticsFilterControllerState extends Equatable {
  final TimeFrameEnum? selectedTimeFrame;
  final DateTimeRange? selectedDateRange;

  const NewsDashboardStatisticsFilterControllerState(
      {this.selectedTimeFrame, this.selectedDateRange});

  //Any filter selected
  bool get isFilterSelected =>
      selectedTimeFrame != null || selectedDateRange != null;

  @override
  List<Object?> get props => [selectedTimeFrame, selectedDateRange];
}
