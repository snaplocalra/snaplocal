import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class NewsStatisticsDataWidget extends StatelessWidget {
  final String title;
  final int value;
  const NewsStatisticsDataWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.formatNumber(),
              style: TextStyle(
                fontSize: 25,
                color: ApplicationColours.themeLightPinkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
