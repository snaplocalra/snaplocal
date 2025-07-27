import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/profile/profile_level/model/level_badge_model.dart';
import 'package:snap_local/profile/profile_level/widget/profile_level_dialog.dart';

class LevelBadgeWidget extends StatelessWidget {
  const LevelBadgeWidget({
    super.key,
    required this.levelBadgeModel,
    required this.userId,
    required this.isOfficialUser,
    this.size = 40,
    this.showName = false,
  });

  final LevelBadgeModel levelBadgeModel;
  final String userId;
  final bool isOfficialUser;
  final double size;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!isOfficialUser) {
          showDialog(
          context: context,
          builder: (context) => ProfileLevelDialog(
            userId: userId,
          ),
        );
        }
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Level Badge
        SvgPicture.network(
          levelBadgeModel.imageUrl,
          height: size,
          width: size,
          fit: BoxFit.scaleDown,
        ),

        // Level Badge Name
        if (showName)
          Text(
            levelBadgeModel.levelBadge.title,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
      ]),
    );
  }
}
