import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/helper/password_validator/logic/password_strength_validator/password_strength_validator_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PasswordStrengthDisplayWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final AlignmentGeometry alignment;
  const PasswordStrengthDisplayWidget({
    super.key,
    required this.passwordController,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PasswordStrengthValidatorCubit(passwordController),
        child: BlocBuilder<PasswordStrengthValidatorCubit,
            PasswordStrengthValidatorState>(
          builder: (context, state) {
            final passwordStrength = state.passwordStrength;
            return passwordStrength == null
                // If password strength is null, return an empty widget
                ? const SizedBox.shrink()
                // Display the password strength
                : Align(
                    alignment: alignment,
                    child: Wrap(
                      children: [
                        Text(
                          "${tr(LocaleKeys.yourPasswordIs)}: ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          tr(passwordStrength.displayName),
                          style: TextStyle(
                            color: passwordStrength.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ));
  }
}
