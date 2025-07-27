import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/widget/news_channel_statistics_data.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_statistics/news_dashboard_statistics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_statistics_filter_controller/news_dashboard_statistics_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/widget/statistics_filter_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class DashboardStatisticsWidget extends StatefulWidget {
  final String channelId;
  const DashboardStatisticsWidget({
    super.key,
    required this.channelId,
  });

  @override
  State<DashboardStatisticsWidget> createState() =>
      _DashboardStatisticsWidgetState();
}

class _DashboardStatisticsWidgetState extends State<DashboardStatisticsWidget> {
  final newsDashboardStatisticsFilterControllerCubit =
      NewsDashboardStatisticsFilterControllerCubit();

  @override
  void initState() {
    super.initState();
    newsDashboardStatisticsFilterControllerCubit.stream.listen((state) {
      if (state.isFilterSelected && mounted) {
        context
            .read<NewsDashboardStatisticsCubit>()
            .fetchNewsDashboardStatistics(
              channelId: widget.channelId,
              timeFrame: state.selectedTimeFrame,
              dateTimeRange: state.selectedDateRange,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: newsDashboardStatisticsFilterControllerCubit,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            //heading
            Text(
              tr(LocaleKeys.myStatistics),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ApplicationColours.themeLightPinkColor,
              ),
            ),

            //Filter options
            BlocBuilder<NewsDashboardStatisticsFilterControllerCubit,
                NewsDashboardStatisticsFilterControllerState>(
              builder: (context, newsDashboardStatisticsFilterControllerState) {
                final timeFrameEnum =
                    newsDashboardStatisticsFilterControllerState
                        .selectedTimeFrame;

                final dateRange = newsDashboardStatisticsFilterControllerState
                    .selectedDateRange;

                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    children: [
                      //Time frame filter
                      Expanded(
                        child: TimeFrameFilter(timeFrameEnum: timeFrameEnum),
                      ),
                      const SizedBox(width: 10),
                      //Date range picker
                      Expanded(
                        child: DateRangeFilterWidget(dateRange: dateRange),
                      ),
                    ],
                  ),
                );
              },
            ),

            //BlocBuilder to get the statistics data
            BlocBuilder<NewsDashboardStatisticsCubit,
                NewsDashboardStatisticsState>(
              builder: (context, state) {
                if (state is NewsDashboardLoaded) {
                  //Dashboard statistics data
                  final dashboardStatistics =
                      state.newsDashboardChannelStatistics;

                  return Column(
                    children: [
                      Row(
                        children: [
                          NewsStatisticsDataWidget(
                            title: tr(LocaleKeys.totalNewsSubmitted),
                            value: dashboardStatistics.totalNewsSubmitted,
                          ),
                          NewsStatisticsDataWidget(
                            title: tr(LocaleKeys.totalApprovedPosts),
                            value: dashboardStatistics.totalApprovedPosts,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          NewsStatisticsDataWidget(
                            title: tr(LocaleKeys.totalViews),
                            value: dashboardStatistics.totalViews,
                          ),
                          NewsStatisticsDataWidget(
                            title: tr(LocaleKeys.totalShares),
                            value: dashboardStatistics.totalShares,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          NewsStatisticsDataWidget(
                            title: tr(LocaleKeys.totalLikes),
                            value: dashboardStatistics.totalLikes,
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is NewsDashboardLoadFailed) {
                  return ErrorTextWidget(error: state.errorMessage);
                }
                return const ThemeSpinner();
              },
            ),
          ],
        ),
      ),
    );
  }
}
