import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_timeframe_type.dart';

part 'analytics_filter_state.dart';

class AnalyticsFilterCubit extends Cubit<AnalyticsFilterState> {
  AnalyticsFilterCubit()
      : super(
          const AnalyticsFilterState(
            dateTimeRange: null,
            timeframe: AnalyticsTimeframeType.daily,
          ),
        );

  void setDateTimeRange(DateTimeRange dateTimeRange) {
    emit(state.copyWith(dateTimeRange: dateTimeRange));
  }

  void setTimeframe(AnalyticsTimeframeType timeframe) {
    emit(state.copyWith(timeframe: timeframe));
  }
}
