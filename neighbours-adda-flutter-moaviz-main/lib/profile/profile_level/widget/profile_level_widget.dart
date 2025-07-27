import 'package:flutter/material.dart';
import 'package:snap_local/profile/profile_level/model/profile_level_model.dart';
import 'package:snap_local/profile/profile_level/widget/level_range_widget.dart';

class ProfileLevelWidget extends StatelessWidget {
  final List<LevelsModel> levels;
  const ProfileLevelWidget({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        return Column(
          children: [
            LevelRangeWidget(level: level),

            //Divider
            if (index != levels.length - 1)
              const Divider(thickness: 2, height: 20),
          ],
        );
      },
    );
  }
}
