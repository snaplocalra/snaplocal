import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/helper/password_validator/widget/password_validator_widget.dart';
import 'package:snap_local/authentication/logic/active_button/active_button_cubit.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/auth_header_text.dart';
import 'package:snap_local/profile/profile_settings/modules/reset_password/logic/reset_password/reset_password_cubit.dart';
import 'package:snap_local/profile/profile_settings/modules/reset_password/repository/reset_password_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  static const routeName = 'reset_password';
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final activeButtonCubit = ActiveButtonCubit();

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  bool showOldPassword = false;
  bool showPassword = false;
  bool showReEnterPassword = false;

  bool isPasswordValid = false;
  //Enable button when password is valid and confirm password is same as new password
  void validateContinueButton() {
    if (isPasswordValid &&
        oldPasswordController.text.isNotEmpty &&
        newPasswordController.text == confirmPasswordController.text) {
      activeButtonCubit.changeStatus(true);
    } else {
      activeButtonCubit.changeStatus(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ResetPasswordCubit(ResetPasswordRepository()),
        ),
        BlocProvider.value(value: activeButtonCubit),
      ],
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, resetPasswordState) {
          if (resetPasswordState.requestSuccess) {
            GoRouter.of(context).pop();
          }
        },
        builder: (context, resetPasswordState) {
          return PopScope(
            canPop: willPopScope(!resetPasswordState.requestLoading),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: ThemeAppBar(
                onPop: () async =>
                    willPopScope(!resetPasswordState.requestLoading),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthHeaderText(
                          header1: tr(LocaleKeys.resetPassword),
                          header2: tr(LocaleKeys.resetPasswordDescription),
                          header2FontSize: 14,
                        ),
                        const SizedBox(height: 20),
                        const TextFieldHeadingTextWidget(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          text: 'Old Password',
                          fontWeight: FontWeight.w500,
                        ),
                        StatefulBuilder(builder: (context, eyeState) {
                          return ThemeTextFormField(
                            controller: oldPasswordController,
                            hint: "Enter Old Password",
                            style: const TextStyle(fontSize: 14),
                            hintStyle: const TextStyle(fontSize: 14),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            obscureText: !showOldPassword,
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                showOldPassword
                                    ? FeatherIcons.eye
                                    : FeatherIcons.eyeOff,
                                size: 18,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showOldPassword = !showOldPassword;
                                eyeState(() {});
                              },
                            ),
                            onChanged: (_) {
                              validateContinueButton();
                            },
                          );
                        }),
                        const SizedBox(height: 10),
                        const TextFieldHeadingTextWidget(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          text: 'New Password',
                          fontWeight: FontWeight.w500,
                        ),
                        StatefulBuilder(builder: (context, eyeState) {
                          return ThemeTextFormField(
                            controller: newPasswordController,
                            hint: tr(LocaleKeys.enterNewPassword),
                            style: const TextStyle(fontSize: 14),
                            hintStyle: const TextStyle(fontSize: 14),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            obscureText: !showPassword,
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                showPassword
                                    ? FeatherIcons.eye
                                    : FeatherIcons.eyeOff,
                                size: 18,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showPassword = !showPassword;
                                eyeState(() {});
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                        //Password Validator
                        PasswordValidatorWidget(
                          passwordController: newPasswordController,
                          onPasswordValidationChanged: (bool isValid) {
                            isPasswordValid = isValid;
                            validateContinueButton();
                          },
                        ),
                        const SizedBox(height: 10),
                        const TextFieldHeadingTextWidget(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          text: 'Confirm New Password',
                          fontWeight: FontWeight.w500,
                        ),
                        StatefulBuilder(builder: (context, eyeState) {
                          return ThemeTextFormField(
                            controller: confirmPasswordController,
                            hint: "Enter Confirm New Password",
                            style: const TextStyle(fontSize: 14),
                            hintStyle: const TextStyle(fontSize: 14),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            obscureText: !showReEnterPassword,
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                showReEnterPassword
                                    ? FeatherIcons.eye
                                    : FeatherIcons.eyeOff,
                                size: 18,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showReEnterPassword = !showReEnterPassword;
                                eyeState(() {});
                              },
                            ),
                            onChanged: (_) {
                              validateContinueButton();
                            },
                            validator: (text) {
                              return TextFieldValidator
                                  .confirmPasswordValidator(
                                text,
                                matcher: newPasswordController.text,
                              );
                            },
                          );
                        }),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: BlocBuilder<ActiveButtonCubit,
                                ActiveButtonState>(
                              builder: (context, activeButtonState) {
                                return ThemeElevatedButton(
                                  disableButton:
                                      !activeButtonState.activeNextButton,
                                  buttonName: tr(LocaleKeys.continueButton),
                                  showLoadingSpinner:
                                      resetPasswordState.requestLoading,
                                  onPressed: () {
                                    //close the soft keyboard
                                    FocusScope.of(context).unfocus();
                                    if (formkey.currentState!.validate()) {
                                      context
                                          .read<ResetPasswordCubit>()
                                          .resetPassword(
                                            oldPassword: oldPasswordController
                                                .text
                                                .trim(),
                                            newPassword: newPasswordController
                                                .text
                                                .trim(),
                                          );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
