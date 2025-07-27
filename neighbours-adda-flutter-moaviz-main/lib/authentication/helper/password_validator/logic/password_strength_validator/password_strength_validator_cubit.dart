import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'password_strength_validator_state.dart';

class PasswordStrengthValidatorCubit
    extends Cubit<PasswordStrengthValidatorState> {
  final TextEditingController passwordController;
  PasswordStrengthValidatorCubit(this.passwordController)
      : super(const PasswordStrengthValidatorState()) {
    //add listener to the password controller
    passwordController.addListener(() {
      _checkPasswordStrength();
    });
  }

  //remove the password strength
  void _removePasswordStrength() {
    emit(state.copyWith(passwordStrength: null));
  }

  //check password strength
  // 1. if only numbers or alphabets then it is weak
  // 2. if numbers and alphabets then it is medium
  // 3. if numbers, alphabets and special characters then it is strong
  void _checkPasswordStrength() {
    final password = passwordController.text;
    if (password.isEmpty) {
      _removePasswordStrength();
      return;
    }

    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasLetters && hasNumbers && hasSpecialCharacters) {
      emit(state.copyWith(passwordStrength: PasswordStrength.strong));
    } else if (hasLetters && hasNumbers) {
      emit(state.copyWith(passwordStrength: PasswordStrength.medium));
    } else {
      emit(state.copyWith(passwordStrength: PasswordStrength.weak));
    }
  }
}
