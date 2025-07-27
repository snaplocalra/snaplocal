import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_overview_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class AnalyticsOverViewWidget extends StatelessWidget {
  const AnalyticsOverViewWidget({
    super.key,
    required this.analyticsData,
  });

  final AnalyticsOverviewModel analyticsData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ApplicationColours.themeLightPinkColor.withOpacity(0.1),
        boxShadow: analyticsData.isGraphAvailable
            ? [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.5), // Darker shadow for 3D effect
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(2, 2), // Shadow position
                ),
                BoxShadow(
                  color: Colors.white
                      .withOpacity(0.8), // Lighter shadow for upper side
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset:
                      const Offset(-2, -2), // Offset in the opposite direction
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  analyticsData.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: ApplicationColours.themeBlueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Graph icon with 3D effect
              Visibility(
                visible: analyticsData.isGraphAvailable,
                child: Container(
                  decoration: BoxDecoration(
                    color: ApplicationColours.themePinkColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ApplicationColours.themeBlueColor,
                      width: 0.15,
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    FeatherIcons.barChart2,
                    color: ApplicationColours.themeBlueColor,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          Text(
            analyticsData.value.formatNumber(),
            style: TextStyle(
              fontSize: 28,
              color: ApplicationColours.themePinkColor,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.grey.shade500,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
