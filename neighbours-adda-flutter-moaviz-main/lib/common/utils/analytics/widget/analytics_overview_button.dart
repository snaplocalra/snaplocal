import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/screen/analytics_overview_screen.dart';

class AnalyticsOverviewButton extends StatelessWidget {
  final String moduleId;
  final AnalyticsModuleType moduleType;
  final double height;
  final double textFontSize;
  final Color? backgroundColor;

  const AnalyticsOverviewButton({
    super.key,
    required this.moduleId,
    required this.moduleType,
    this.height = 40,
    this.backgroundColor,
    this.textFontSize=13,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: ThemeElevatedButton(
        buttonName: "Analytics Overview",
        prefix: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.analytics),
        ),
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        width: 200,
        height: height,
        textFontSize: textFontSize,
        onPressed: () {
          GoRouter.of(context).pushNamed(
            AnalyticsOverviewScreen.routeName,
            queryParameters: {
              'module_id': moduleId,
              'module_type': moduleType.jsonValue,
            },
          );
        },
      ),
    );
  }
}
