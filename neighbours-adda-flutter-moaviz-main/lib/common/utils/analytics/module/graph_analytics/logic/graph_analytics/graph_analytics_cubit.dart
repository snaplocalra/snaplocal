import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_timeframe_type.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/model/graph_analytics_model.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/repository/graph_analytics_repository.dart';

part 'graph_analytics_state.dart';

class GraphAnalyticsCubit extends Cubit<GraphAnalyticsState> {
  final GraphAnalyticsRepository _graphAnalyticsRepository;

  GraphAnalyticsCubit(this._graphAnalyticsRepository)
      : super(GraphAnalyticsInitial());

  Future<void> fetchGraphAnalytics({
    required String moduleId,
    required String analyticsOverviewId,
    required AnalyticsModuleType moduleType,
    required AnalyticsTimeframeType? timeFrame,
    required DateTimeRange? dateRange,
  }) async {
    try {
      // Check if the state is not GraphAnalyticsLoaded
      if (state is! GraphAnalyticsLoaded) {
        // Emit GraphAnalyticsLoading
        emit(GraphAnalyticsLoading());
      }

      // Fetch graph analytics
      final graphAnalytics =
          await _graphAnalyticsRepository.fetchGraphAnalytics(
        moduleId: moduleId,
        analyticsOverviewId: analyticsOverviewId,
        moduleType: moduleType,
        timeFrame: timeFrame,
        dateRange: dateRange,
      );

      // Emit GraphAnalyticsLoaded
      emit(GraphAnalyticsLoaded(data: graphAnalytics));
    } catch (e) {
      emit(GraphAnalyticsError(message: e.toString()));
    }
  }
}
