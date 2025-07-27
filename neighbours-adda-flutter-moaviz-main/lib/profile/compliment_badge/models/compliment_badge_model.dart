abstract class ComplimentBadgeModel {
  final String id;
  final String name;
  final String image;
  final int count;
  bool isSelected;

  ComplimentBadgeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isSelected,
    required this.count,
  });

  /// Returns true if the badge is newly selected and not assigned previously
  bool get isNewSelection;

  /// Returns true if the badge is assigned on server
  bool get isAssigned;
}

class ComplimentBadgeSender extends ComplimentBadgeModel {
  bool _isComplimentGiven;

  ComplimentBadgeSender({
    required super.id,
    required super.name,
    required super.image,
    required super.count,
    required bool isComplimentGiven,
    required super.isSelected,
  }) : _isComplimentGiven = isComplimentGiven;

  factory ComplimentBadgeSender.fromMap(Map<String, dynamic> map) {
    return ComplimentBadgeSender(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      count: map['count'],
      isComplimentGiven: map['is_compliment_given'] ?? false,
      isSelected: map['is_compliment_given'] ?? false,
    );
  }

  @override
  bool get isNewSelection => isSelected && !_isComplimentGiven;

  @override
  bool get isAssigned => _isComplimentGiven;
}

class OwnProfileComplimentBadge extends ComplimentBadgeModel {
  bool _isAssigned;

  OwnProfileComplimentBadge({
    required super.count,
    required super.id,
    required super.name,
    required super.image,
    required super.isSelected,
    required bool isAssigned,
  }) : _isAssigned = isAssigned;

  factory OwnProfileComplimentBadge.fromMap(Map<String, dynamic> map) {
    return OwnProfileComplimentBadge(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      count: map['progress_bar'] ?? map['count'] ?? 0,
      isAssigned: map['is_assigned'] ?? false,
      isSelected: map['is_assigned'] ?? false,
    );
  }

  @override
  bool get isNewSelection => isSelected && !_isAssigned;

  @override
  bool get isAssigned => _isAssigned;
}
