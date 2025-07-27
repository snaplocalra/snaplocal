part of 'social_login_bloc.dart';

class SocialLoginState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  final bool profileActionRequired;
  final User? firebaseUser;
  final AuthenticatedUserDetails? authenticatedUserDetails;
  final SocialLoginEvent? event;
  final String? error;
  const SocialLoginState({
    this.requestLoading = false,
    this.requestSuccess = false,
    this.profileActionRequired = false,
    this.firebaseUser,
    this.authenticatedUserDetails,
    this.event,
    this.error,
  });

  @override
  List<Object?> get props => [
        requestLoading,
        requestSuccess,
        profileActionRequired,
        firebaseUser,
        authenticatedUserDetails,
        event,
        error,
      ];

  SocialLoginState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
    bool? profileActionRequired,
    User? firebaseUser,
    AuthenticatedUserDetails? authenticatedUserDetails,
    SocialLoginEvent? event,
    String? error,
  }) {
    return SocialLoginState(
      firebaseUser: firebaseUser,
      authenticatedUserDetails: authenticatedUserDetails,
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      profileActionRequired: profileActionRequired ?? false,
      event: event ?? this.event,
      error: error,
    );
  }
}
