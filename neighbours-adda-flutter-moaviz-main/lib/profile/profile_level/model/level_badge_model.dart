import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:snap_local/profile/profile_level/model/level_badge.dart';

import '../../../utility/constant/errors.dart';

class LevelBadgeModel extends Equatable {
  final String imageUrl;
  final String points;
  final String color;
  final LevelBadgeType levelBadge;
  final bool isVerified;

  const LevelBadgeModel({
    required this.imageUrl,
    required this.points,
    required this.color,
    required this.levelBadge,
    required this.isVerified,
  });

  factory LevelBadgeModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLevelBadge(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLevelBadge(map);
    }
  }

  static LevelBadgeModel _buildLevelBadge(Map<String, dynamic> map) {
    return LevelBadgeModel(
      imageUrl: map['image'],
      points: map['points'],
      color: map['color_code'] ?? "ffffff",
      levelBadge: LevelBadgeType.fromString(map['type']),
      isVerified: map['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'image': imageUrl,
    'points': points,
    'color_code': color,
    'type': levelBadge.title,
    'is_verified': isVerified,
  };

  String toJson() => json.encode(toMap());

  factory LevelBadgeModel.fromJson(String source) =>
      LevelBadgeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [imageUrl, points, levelBadge];
}
