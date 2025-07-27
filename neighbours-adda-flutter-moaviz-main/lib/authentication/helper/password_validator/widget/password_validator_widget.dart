import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/helper/password_validator/logic/password_validator/password_validator_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PasswordValidatorWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final void Function(bool isPasswordValid) onPasswordValidationChanged;
  const PasswordValidatorWidget({
    super.key,
    required this.passwordController,
    required this.onPasswordValidationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            PasswordValidatorCubit()..validatePassword(passwordController),
        child: BlocConsumer<PasswordValidatorCubit, PasswordValidatorState>(
          listener: (context, state) {
            final isPasswordValid = state.passwordValidationRules
                .every((rule) => rule.isRuleValid(passwordController.text));
            onPasswordValidationChanged(isPasswordValid);
          },
          builder: (context, state) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.passwordValidationRules.length,
              itemBuilder: (context, index) {
                final rule = state.passwordValidationRules[index];
                final isRuleValid = rule.isRuleValid(passwordController.text);
                return Row(
                  children: [
                    Icon(
                      isRuleValid ? Icons.check : Icons.fiber_manual_record,
                      color: isRuleValid
                          ? Colors.green
                          : ApplicationColours.themeBlueColor,
                      size: isRuleValid ? 14 : 10,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rule.ruleDescription,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}
