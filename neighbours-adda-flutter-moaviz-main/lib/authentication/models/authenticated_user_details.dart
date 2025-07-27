class AuthenticatedUserDetails {
  final String accessToken;
  final String userId;

  AuthenticatedUserDetails({
    required this.accessToken,
    required this.userId,
  });

  factory AuthenticatedUserDetails.fromMap(Map<String, dynamic> map) {
    return AuthenticatedUserDetails(
      accessToken: map['access_token'],
      userId: map['user_id'],
    );
  }
}
