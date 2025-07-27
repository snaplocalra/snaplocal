import 'package:snap_local/authentication/models/authenticated_user_details.dart';

class SocialLoginResponse {
  final bool isUserProfileCompleted;
  final AuthenticatedUserDetails? authenticatedUserDetails;

  SocialLoginResponse({
    this.isUserProfileCompleted = false,
    this.authenticatedUserDetails,
  });

  factory SocialLoginResponse.fromMap(Map<String, dynamic> map) {
    final isUserProfileCompleted = map['is_user_profile_completed'] ?? false;
    return SocialLoginResponse(
      isUserProfileCompleted: isUserProfileCompleted,
      authenticatedUserDetails: isUserProfileCompleted
          ? map['user_credentials'] == null
              ? null
              : AuthenticatedUserDetails.fromMap(map['user_credentials'])
          : null,
    );
  }
}
