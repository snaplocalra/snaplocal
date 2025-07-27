part of 'user_consent_handler_cubit.dart';

class UserConsentHandlerState extends Equatable {
  final bool languageSelected;
  final bool termsAgreed;
  final bool loading;
  const UserConsentHandlerState({
    this.languageSelected = false,
    this.termsAgreed = false,
    this.loading = false,
  });

  @override
  List<Object> get props => [languageSelected, termsAgreed, loading];

  UserConsentHandlerState copyWith({
    bool? languageSelected,
    bool? termsAgreed,
    bool? loading,
  }) {
    return UserConsentHandlerState(
      languageSelected: languageSelected ?? false,
      termsAgreed: termsAgreed ?? false,
      loading: loading ?? false,
    );
  }
}
