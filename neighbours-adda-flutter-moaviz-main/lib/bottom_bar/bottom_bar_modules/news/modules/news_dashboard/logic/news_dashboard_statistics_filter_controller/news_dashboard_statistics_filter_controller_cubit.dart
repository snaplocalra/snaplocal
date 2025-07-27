import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/time_frame_enum.dart';

part 'news_dashboard_statistics_filter_controller_state.dart';

class NewsDashboardStatisticsFilterControllerCubit
    extends Cubit<NewsDashboardStatisticsFilterControllerState> {
  NewsDashboardStatisticsFilterControllerCubit()
      : super(
          const NewsDashboardStatisticsFilterControllerState(
            selectedTimeFrame: null,
            selectedDateRange: null,
          ),
        );

  void setTimeFrame(TimeFrameEnum? timeFrame) {
    emit(NewsDashboardStatisticsFilterControllerState(
      selectedTimeFrame: timeFrame,
    ));
  }

  void setDateRange(DateTimeRange? dateRange) {
    emit(NewsDashboardStatisticsFilterControllerState(
      selectedDateRange: dateRange,
    ));
  }
}
