import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/news_dashboard_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/time_frame_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/repository/news_dashboard_repository.dart';

part 'news_dashboard_statistics_state.dart';

class NewsDashboardStatisticsCubit extends Cubit<NewsDashboardStatisticsState> {
  final NewsDashboardRepository newsDashboardRepository;

  NewsDashboardStatisticsCubit(this.newsDashboardRepository)
      : super(NewsDashboardInitial());

  //Fetch the news dashboard
  Future<void> fetchNewsDashboardStatistics({
    required String channelId,
    TimeFrameEnum? timeFrame,
    DateTimeRange? dateTimeRange,
  }) async {
    try {
      emit(NewsDashboardLoading());
      final newsDashboardChannelStatistics =
          await newsDashboardRepository.getNewsDashboardStatistics(
        timeFrame: timeFrame,
        dateTimeRange: dateTimeRange,
        channelId: channelId,
      );
      emit(NewsDashboardLoaded(newsDashboardChannelStatistics));
    } catch (e) {
      emit(NewsDashboardLoadFailed(errorMessage: e.toString()));
    }
  }
}
