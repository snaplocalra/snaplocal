import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/logic/analytics_filter/analytics_filter_cubit.dart';
import 'package:snap_local/common/utils/analytics/logic/analytics_overview/analytics_overview_cubit.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/screen/graph_analytics_screen.dart';
import 'package:snap_local/common/utils/analytics/repository/analytics_overview_repository.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_filter_widget.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class AnalyticsOverviewScreen extends StatefulWidget {
  final String moduleId;
  final AnalyticsModuleType moduleType;
  const AnalyticsOverviewScreen({
    super.key,
    required this.moduleId,
    required this.moduleType,
  });

  static const String routeName = 'analytics_overview';

  @override
  State<AnalyticsOverviewScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsOverviewScreen> {
  final _analyticsFilterCubit = AnalyticsFilterCubit();

  // Analytics Overview Cubit
  late final AnalyticsOverviewCubit _analyticsOverviewCubit =
      AnalyticsOverviewCubit(AnalyticsOverviewRepository());

  void _fetchAnalyticsOverview() {
    _analyticsOverviewCubit.fetchAnalyticsOverview(
      moduleId: widget.moduleId,
      moduleType: widget.moduleType,
      timeFrame: _analyticsFilterCubit.state.timeframe,
      dateRange: _analyticsFilterCubit.state.dateTimeRange,
    );
  }

  @override
  initState() {
    super.initState();
    _fetchAnalyticsOverview();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _analyticsOverviewCubit),
        BlocProvider.value(value: _analyticsFilterCubit),
      ],
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
                "Your ${widget.moduleType.displayValue} Analytics",
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
              AnalyticsFilterWidget(onRefresh: _fetchAnalyticsOverview),

              //Annalytics Overview data
              Expanded(
                child:
                    BlocBuilder<AnalyticsOverviewCubit, AnalyticsOverviewState>(
                  builder: (context, state) {
                    if (state is AnalyticsOverviewLoading) {
                      return const ThemeSpinner();
                    } else if (state is AnalyticsOverviewLoaded) {
                      final logs = state.data;

                      return logs.isEmpty
                          ? const Center(
                              child: ErrorTextWidget(
                                error: "No analytics data available",
                              ),
                            )
                          :
                          // GridView
                          GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                // Adjust the number of columns as needed
                                crossAxisCount: 2,
                                // Adjust the aspect ratio as needed
                                childAspectRatio: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final analyticsData = logs[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (analyticsData.isGraphAvailable) {
                                      // Navigate to GraphAnalyticsScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: _analyticsFilterCubit,
                                              child: GraphAnalyticsScreen(
                                                moduleId: widget.moduleId,
                                                analyticsOverviewId:
                                                    analyticsData.id,
                                                analyticsOverviewName:
                                                    analyticsData.name,
                                                moduleType: widget.moduleType,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: AnalyticsOverViewWidget(
                                    analyticsData: analyticsData,
                                  ),
                                );
                              },
                            );
                    } else if (state is AnalyticsOverviewError) {
                      return ErrorTextWidget(error: state.message);
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
