import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_overview_model.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_timeframe_type.dart';
import 'package:snap_local/common/utils/analytics/repository/analytics_overview_repository.dart';

part 'analytics_overview_state.dart';

class AnalyticsOverviewCubit extends Cubit<AnalyticsOverviewState> {
  final AnalyticsOverviewRepository _analyticsOverviewRepository;

  AnalyticsOverviewCubit(this._analyticsOverviewRepository)
      : super(AnalyticsOverviewInitial());

  void fetchAnalyticsOverview({
    required String moduleId,
    required AnalyticsModuleType moduleType,
    required AnalyticsTimeframeType? timeFrame,
    required DateTimeRange? dateRange,
  }) async {
    emit(AnalyticsOverviewLoading());
    try {
      final analyticsOverview =
          await _analyticsOverviewRepository.fetchAnalyticsOverview(
        moduleId: moduleId,
        moduleType: moduleType,
        timeFrame: timeFrame,
        dateRange: dateRange,
      );
      emit(AnalyticsOverviewLoaded(analyticsOverview));
    } catch (e) {
      emit(AnalyticsOverviewError(e.toString()));
    }
  }
}
