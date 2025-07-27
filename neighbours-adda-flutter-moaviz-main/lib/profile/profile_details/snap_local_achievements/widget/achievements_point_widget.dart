import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class AchievementsPointWidget extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const AchievementsPointWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OctagonWidget(
      shapeSize: 80,
      borderWidth: 0.5,
      borderColor: Colors.black,
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.formatNumber(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
