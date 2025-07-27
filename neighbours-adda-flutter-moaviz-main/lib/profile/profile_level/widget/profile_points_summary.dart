import 'package:flutter/material.dart';
import 'package:snap_local/profile/profile_level/model/profile_points_summary.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class ProfilePointsSummaryWidget extends StatelessWidget {
  final ProfilePointsSummaryModel profilePointsSummary;
  const ProfilePointsSummaryWidget({
    super.key,
    required this.profilePointsSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //heading
          Text(
            "Points Summary",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ApplicationColours.themeLightPinkColor,
            ),
          ),

          //Divider
          const Divider(thickness: 2),

          //Points summary
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profilePointsSummary.profilePointsList.length,
            itemBuilder: (context, index) {
              return PointsSummaryWidget(
                profilePoints: profilePointsSummary.profilePointsList[index],
              );
            },
          ),

          //Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profilePointsSummary.grandTotalPoints.formatNumber(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PointsSummaryWidget extends StatelessWidget {
  final ProfilePointModel profilePoints;
  const PointsSummaryWidget({super.key, required this.profilePoints});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Referral Rewards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profilePoints.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${profilePoints.earnedPointCount}x${profilePoints.pointValue}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              profilePoints.totalEarnedPoints.formatNumber(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        //Divider
        const Divider(thickness: 2),
      ],
    );
  }
}
