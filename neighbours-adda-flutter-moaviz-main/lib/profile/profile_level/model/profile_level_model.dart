import 'package:snap_local/profile/profile_level/model/level_badge.dart';
import 'package:snap_local/profile/profile_level/model/profile_points_summary.dart';

class ProfileLevelModel {
  final List<LevelsModel> levels;
  final ProfilePointsSummaryModel profilePointsSummary;

  ProfileLevelModel({
    required this.levels,
    required this.profilePointsSummary,
  });

  factory ProfileLevelModel.fromJson(Map<String, dynamic> json) =>
      ProfileLevelModel(
        levels: List<LevelsModel>.from(
          json["levels"].map((x) => LevelsModel.fromJson(x)),
        ),
        profilePointsSummary:
            ProfilePointsSummaryModel.fromJson(json["profile_points_summary"]),
      );
}

class LevelsModel {
  final String id;
  final String badge;
  final LevelBadgeType levelBadge;

  final String minimumPoints;
  final String maximumPoints;
  final bool assigned;

  LevelsModel({
    required this.id,
    required this.badge,
    required this.levelBadge,
    required this.minimumPoints,
    required this.maximumPoints,
    required this.assigned,
  });

  factory LevelsModel.fromJson(Map<String, dynamic> json) => LevelsModel(
        id: json["id"],
        badge: json["badge"],
        levelBadge: LevelBadgeType.fromString(json["badge_name"]),
        minimumPoints: json["minimum_points"],
        maximumPoints: json["maximum_points"],
        assigned: json["assigned"],
      );
}
