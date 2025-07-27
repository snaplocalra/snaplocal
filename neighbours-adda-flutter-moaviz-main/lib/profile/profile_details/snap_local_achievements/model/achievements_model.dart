class AchievementsModel {
  final List<AchievementPoint> points;
  final int totalPoints;

  const AchievementsModel({
    required this.points,
    required this.totalPoints,
  });

//from map
  factory AchievementsModel.fromMap(Map<String, dynamic> map) {
    return AchievementsModel(
      points: List.from(map['points'])
          .map((e) => AchievementPoint.fromMap(e))
          .toList(),
      totalPoints: map['grand_total_points'],
    );
  }
}

class AchievementPoint {
  final String title;
  final int value;

  const AchievementPoint({
    required this.title,
    required this.value,
  });

  //from map
  factory AchievementPoint.fromMap(Map<String, dynamic> map) {
    return AchievementPoint(
      title: map['title'],
      value: map['count'],
    );
  }
}
