// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'password_strength_validator_cubit.dart';

class PasswordStrengthValidatorState extends Equatable {
  final PasswordStrength? passwordStrength;
  const PasswordStrengthValidatorState({this.passwordStrength});

  @override
  List<Object?> get props => [passwordStrength];

  //copyWith method
  PasswordStrengthValidatorState copyWith(
      {PasswordStrength? passwordStrength}) {
    return PasswordStrengthValidatorState(passwordStrength: passwordStrength);
  }
}

enum PasswordStrength {
  weak(
    displayName: LocaleKeys.weak,
    color: Colors.red,
  ),

  medium(
    displayName: LocaleKeys.medium,
    color: Colors.orange,
  ),

  strong(
    displayName: LocaleKeys.strong,
    color: Colors.green,
  );

  final String displayName;
  final Color color;

  const PasswordStrength({
    required this.displayName,
    required this.color,
  });
}
