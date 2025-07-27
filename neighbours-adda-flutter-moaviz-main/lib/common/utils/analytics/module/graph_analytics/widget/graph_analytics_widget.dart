import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/model/graph_analytics_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphAnalyticsWidget extends StatelessWidget {
  final String analyticsOverviewName;
  final List<GraphAnalyticsModel> dataSource;

  const GraphAnalyticsWidget({
    super.key,
    required this.dataSource,
    required this.analyticsOverviewName,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      title: ChartTitle(
        text: analyticsOverviewName,
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      primaryXAxis: const CategoryAxis(
        // Adjust the font size as needed
        labelStyle: TextStyle(
          fontSize: 6,
          fontWeight: FontWeight.w600,
        ),
        // Adjust the size of major ticks as needed
        majorTickLines: MajorTickLines(size: 1),
      ),
      primaryYAxis: const NumericAxis(
        // Adjust the font size as needed
        labelStyle: TextStyle(
          fontSize: 6,
          fontWeight: FontWeight.w600,
        ),
        // Adjust the size of major ticks as needed
        majorTickLines: MajorTickLines(size: 1),
      ),
      tooltipBehavior: TooltipBehavior(enable: false),
      series: <CartesianSeries<GraphAnalyticsModel, String>>[
        SplineSeries<GraphAnalyticsModel, String>(
          dataSource: dataSource,
          xValueMapper: (GraphAnalyticsModel data, _) => data.x,
          yValueMapper: (GraphAnalyticsModel data, _) => data.y,
          name: analyticsOverviewName,
          // Enable data label
          color: ApplicationColours.themePinkColor,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
