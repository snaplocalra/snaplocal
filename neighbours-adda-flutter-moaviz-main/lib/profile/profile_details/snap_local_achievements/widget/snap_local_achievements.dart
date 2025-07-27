import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/logic/snaplocal_achievements/snaplocal_achievements_cubit.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/repository/achievements_repository.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/widget/achievements_circle_widget.dart';

class SnaplocalAchievements extends StatelessWidget {
  final String userId;
  const SnaplocalAchievements({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 400; // Adjust the size as needed

    return BlocProvider(
      create: (context) => SnaplocalAchievementsCubit(AchievementsRepository())
        ..fetchAchievements(userId),
      child:
          BlocBuilder<SnaplocalAchievementsCubit, SnaplocalAchievementsState>(
        builder: (context, snaplocalAchievementsState) {
          if (snaplocalAchievementsState is SnaplocalAchievementsLoaded) {
            final achievementsData =
                snaplocalAchievementsState.achievementsModel;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  const Text(
                    "Snap Local Achievements",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AchievementsCircleWidget(
                    size: size,
                    userId: userId,
                    achievementsData: achievementsData,
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
