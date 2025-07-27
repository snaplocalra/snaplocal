import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/helper/password_validator/model/password_validation_rule.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'password_validator_state.dart';

class PasswordValidatorCubit extends Cubit<PasswordValidatorState> {
  PasswordValidatorCubit()
      : super(
          PasswordValidatorState(
            passwordValidationRules: [
              PasswordValidationRule(
                ruleDescription: tr(LocaleKeys.minimum8Characters),
                isRuleValid: (password) => password.length >= 8,
              ),
              PasswordValidationRule(
                ruleDescription: tr(LocaleKeys.oneCapitalizedLetter),
                isRuleValid: (password) => password.contains(RegExp(r'[A-Z]')),
              ),
              PasswordValidationRule(
                ruleDescription: tr(LocaleKeys.oneNumber),
                isRuleValid: (password) => password.contains(RegExp(r'[0-9]')),
              ),
              PasswordValidationRule(
                ruleDescription: tr(LocaleKeys.atLeastOneSymbol),
                isRuleValid: (password) => password.contains(RegExp(r'[!@#$]')),
              ),
            ],
          ),
        );

  void validatePassword(TextEditingController passwordController) {
    passwordController.addListener(() {
      if (isClosed) {
        return;
      }
      //Refresh the state to update the UI
      emit(state.copyWith(loading: true));
      emit(state.copyWith(loading: false));
    });
  }
}
