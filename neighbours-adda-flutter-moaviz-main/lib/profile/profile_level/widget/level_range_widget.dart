import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/profile/profile_level/model/profile_level_model.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class LevelRangeWidget extends StatelessWidget {
  const LevelRangeWidget({
    super.key,
    required this.level,
  });

  final LevelsModel level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Badge image
              SvgPicture.network(
                level.badge,
                height: 25,
                width: 25,
                fit: BoxFit.cover,
              ),

              // Badge name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  level.levelBadge.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Circle tick
              Visibility(
                visible: level.assigned,
                child: SvgPicture.asset(
                  SVGAssetsImages.greenCircleTick,
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                ),
              ),

              // Spacer
              const Spacer(),

              //level points
              Text(
                "${level.minimumPoints}-${level.maximumPoints}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
