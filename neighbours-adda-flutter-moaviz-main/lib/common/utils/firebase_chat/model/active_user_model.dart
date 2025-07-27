class ActiveUserModel {
  final String id;
  final String name;
  final String profileImageUrl;
  final bool isOnline;
  final DateTime lastSeen;

  ActiveUserModel({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.isOnline,
    required this.lastSeen,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profile_image_url'] as String,
      isOnline: json['is_online'] as bool,
      lastSeen: DateTime.parse(json['last_seen'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image_url': profileImageUrl,
      'is_online': isOnline,
      'last_seen': lastSeen.toIso8601String(),
    };
  }
} 