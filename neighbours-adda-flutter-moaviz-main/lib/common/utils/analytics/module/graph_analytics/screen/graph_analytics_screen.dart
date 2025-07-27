import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/logic/analytics_filter/analytics_filter_cubit.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/logic/graph_analytics/graph_analytics_cubit.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/repository/graph_analytics_repository.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/widget/graph_analytics_widget.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_filter_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class GraphAnalyticsScreen extends StatefulWidget {
  final String moduleId;
  final AnalyticsModuleType moduleType;
  final String analyticsOverviewId;
  final String analyticsOverviewName;
  const GraphAnalyticsScreen({
    super.key,
    required this.moduleId,
    required this.moduleType,
    required this.analyticsOverviewId,
    required this.analyticsOverviewName,
  });

  static const String routeName = 'graph_analytics';

  @override
  State<GraphAnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<GraphAnalyticsScreen> {
  // Analytics Overview Cubit
  late final GraphAnalyticsCubit _graphAnalyticsCubit =
      GraphAnalyticsCubit(GraphAnalyticsRepository());

  void _fetchGraphAnalytics() {
    _graphAnalyticsCubit.fetchGraphAnalytics(
      moduleId: widget.moduleId,
      moduleType: widget.moduleType,
      timeFrame: context.read<AnalyticsFilterCubit>().state.timeframe,
      dateRange: context.read<AnalyticsFilterCubit>().state.dateTimeRange,
      analyticsOverviewId: widget.analyticsOverviewId,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchGraphAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _graphAnalyticsCubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: const IOSBackButton(enableBackground: false),
          backgroundColor: Colors.white,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Graph Analytics for ${widget.analyticsOverviewName}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ApplicationColours.themeBlueColor,
                ),
              ),
              Text(
                "(Only visible to you)",
                style: TextStyle(
                  fontSize: 12,
                  color: ApplicationColours.themeBlueColor,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Analytics Filter
              AnalyticsFilterWidget(onRefresh: _fetchGraphAnalytics),

              //Graph Analytics Widget
              Expanded(
                child: BlocBuilder<GraphAnalyticsCubit, GraphAnalyticsState>(
                  builder: (context, graphAnalyticsState) {
                    if (graphAnalyticsState is GraphAnalyticsLoading) {
                      return const ThemeSpinner();
                    } else if (graphAnalyticsState is GraphAnalyticsLoaded) {
                      final dataSource = graphAnalyticsState.data;

                      return GraphAnalyticsWidget(
                        dataSource: dataSource,
                        analyticsOverviewName: widget.analyticsOverviewName,
                      );
                    } else if (graphAnalyticsState is GraphAnalyticsError) {
                      return ErrorTextWidget(
                        error: graphAnalyticsState.message,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
