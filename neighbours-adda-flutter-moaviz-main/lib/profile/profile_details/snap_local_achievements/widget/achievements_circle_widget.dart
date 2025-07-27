import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/model/achievements_model.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/model/octagon_colors.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/widget/achievements_point_widget.dart';
import 'package:snap_local/profile/profile_level/widget/profile_level_dialog.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class AchievementsCircleWidget extends StatelessWidget {
  const AchievementsCircleWidget({
    super.key,
    required this.size,
    required this.userId,
    required this.achievementsData,
  });

  final double size;
  final String userId;
  final AchievementsModel achievementsData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Snap Local Points
            SnaplocalPointsOctagon(
              achievementsData: achievementsData,
              userId: userId,
            ),

            // Achievements Points in Circular Layout
            ...achievementsData.points.asMap().entries.map(
              (entry) {
                int index = entry.key;
                var point = entry.value;
                double angle =
                    (2 * pi / achievementsData.points.length) * index;
                // Adjust the distance from the center
                double x = (size / 2 - 65) * cos(angle);
                // Adjust the distance from the center
                double y = (size / 2 - 65) * sin(angle);
                return Transform.translate(
                  offset: Offset(x, y),
                  child: FittedBox(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProfileLevelDialog(
                            userId: userId,
                          ),
                        );
                      },
                      child: AchievementsPointWidget(
                        title: point.title,
                        value: point.value,
                        color: index < OctagonColors.colors.length
                            ? OctagonColors.colors[index]
                            : Colors.primaries[index % Colors.primaries.length],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SnaplocalPointsOctagon extends StatelessWidget {
  const SnaplocalPointsOctagon({
    super.key,
    required this.achievementsData,
    required this.userId,
  });

  final AchievementsModel achievementsData;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProfileLevelDialog(
            userId: userId,
          ),
        );
      },
      child: OctagonWidget(
        shapeSize: 130,
        borderWidth: 1,
        borderColor: Colors.black,
        child: Container(
          color: ApplicationColours.themeBlueColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                achievementsData.totalPoints.formatNumber(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      "SNAP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ApplicationColours.themeBlueColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    "LOCAL",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "Points",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
