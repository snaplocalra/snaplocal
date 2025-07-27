part of 'password_validator_cubit.dart';

class PasswordValidatorState extends Equatable {
  final bool loading;
  final List<PasswordValidationRule> passwordValidationRules;
  const PasswordValidatorState({
    required this.passwordValidationRules,
    this.loading = false,
  });

  @override
  List<Object> get props => [passwordValidationRules, loading];


//check password strength
// conditions for password strength
// 1. If 
  

  PasswordValidatorState copyWith({
    List<PasswordValidationRule>? passwordValidationRules,
    bool? loading,
  }) {
    return PasswordValidatorState(
      passwordValidationRules:
          passwordValidationRules ?? this.passwordValidationRules,
      loading: loading ?? this.loading,
    );
  }
}

