import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';

class FirebaseUserProfileDetailsModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? mobile;
  final String profileImage;
  final GenderEnum gender;
  final DateTime? lastSeen;
  final List<String> blockedUsers;
  final List<String> blockedUsersHistory;

  const FirebaseUserProfileDetailsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.profileImage,
    this.lastSeen,
    this.blockedUsers = const [],
    this.blockedUsersHistory = const [],
  });

  factory FirebaseUserProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      FirebaseUserProfileDetailsModel(
        id: json["id"],
        name: json["name"],
        email: json["email"] ?? "",
        mobile: json["mobile"],
        profileImage: json["image"] ?? "",
        lastSeen: json['last_seen'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['last_seen'] as int,
                    isUtc: true)
                .toLocal(),
        gender: GenderEnum.fromJson(json["gender"]),
        blockedUsers: json['blocked_users'] == null
            ? []
            : List<String>.from(json['blocked_users']),
        blockedUsersHistory: json['blocked_users_history'] == null
            ? []
            : List<String>.from(json['blocked_users_history']),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
      "mobile": mobile,
      "image": profileImage,
      "gender": gender.name,
      "last_seen": lastSeen?.toUtc().millisecondsSinceEpoch,
      "blocked_users": blockedUsers,
      "blocked_users_history": blockedUsersHistory,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        mobile,
        profileImage,
        gender,
        lastSeen,
        blockedUsers,
        blockedUsersHistory,
      ];
}
