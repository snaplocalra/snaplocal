import '../../../utility/constant/errors.dart';

class ProfilePointsSummaryModel {
  final int grandTotalPoints;
  final List<ProfilePointModel> profilePointsList;

  ProfilePointsSummaryModel({
    required this.grandTotalPoints,
    required this.profilePointsList,
  });

  factory ProfilePointsSummaryModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildFromJson(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildFromJson(json);
    }
  }

  static ProfilePointsSummaryModel _buildFromJson(Map<String, dynamic> json) {
    return ProfilePointsSummaryModel(
      grandTotalPoints: json["grand_total_points"],
      profilePointsList: List<ProfilePointModel>.from(
        json["points_summary"].map((x) => ProfilePointModel.fromJson(x)),
      ),
    );
  }
}

class ProfilePointModel {
  final String title;
  final int earnedPointCount;
  final int pointValue;
  final int totalEarnedPoints;

  ProfilePointModel({
    required this.title,
    required this.earnedPointCount,
    required this.pointValue,
    required this.totalEarnedPoints,
  });

  factory ProfilePointModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildProfilePoint(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildProfilePoint(json);
    }
  }

  static ProfilePointModel _buildProfilePoint(Map<String, dynamic> json) {
    return ProfilePointModel(
      title: json["title"],
      earnedPointCount: json["earned_point_count"],
      pointValue: json["point_value"],
      totalEarnedPoints: json["total_earned_points"],
    );
  }
}
