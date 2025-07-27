import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';

class EditProfileDetailsModel extends Equatable {
  final String name;
  final String? email;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final GenderEnum gender;
  final DateTime? dateOfBirth;
  final String bio;
  final String occupation;
  final String workPlace;
  final LanguageKnownList languageKnownList;

  const EditProfileDetailsModel({
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.coverImageUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.bio,
    required this.occupation,
    required this.workPlace,
    required this.languageKnownList,
  });

  Map<String, dynamic> toMap() {
    final profileDetailsMap = <String, dynamic>{
      "name": name,
      "email": email,
      "image": profileImageUrl?.split('/').last,
      "cover_image": coverImageUrl?.split('/').last,
      "gender": gender.name,
      "dob": dateOfBirth?.millisecondsSinceEpoch,
      "bio": bio,
      "occupation": occupation,
      "work_place": workPlace,
      "languages": languageKnownList.languages.map((e) => e.id).join(','),
    };

    return profileDetailsMap;
  }

  @override
  List<Object?> get props => [
        name,
        email,
        profileImageUrl,
        coverImageUrl,
        gender,
        dateOfBirth,
        bio,
        languageKnownList,
        occupation,
        workPlace,
      ];
}
