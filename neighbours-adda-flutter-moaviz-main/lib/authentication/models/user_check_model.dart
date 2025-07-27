class UserCheckModel {
  final String? userDisplayName;
  final bool isUserRegistered;

  UserCheckModel({
    required this.userDisplayName,
    required this.isUserRegistered,
  });

//fromMap method
  factory UserCheckModel.fromMap(Map<String, dynamic> map) {
    return UserCheckModel(
      userDisplayName: map['name'],
      isUserRegistered: map['is_user_registered'] as bool,
    );
  }

  UserCheckModel copyWith({
    String? userDisplayName,
    bool? isUserRegistered,
  }) {
    return UserCheckModel(
      userDisplayName: userDisplayName ?? this.userDisplayName,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
    );
  }
}
