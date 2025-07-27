import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/helper/password_validator/widget/password_validator_widget.dart';
import 'package:snap_local/authentication/logic/active_button/active_button_cubit.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/models/auth_description_type.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/standard_login_screen.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/auth_image_description_widget.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/reset_password_success_dialog.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userName;
  const ChangePasswordScreen({
    super.key,
    required this.userName,
  });

  static const routeName = 'change_password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final activeButtonCubit = ActiveButtonCubit();

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  bool showPassword = false;
  bool showReEnterPassword = false;
  bool isPasswordValid = false;

  //Enable button when password is valid and confirm password is same as new password
  void validateUpdatePasswordButton() {
    if (isPasswordValid &&
        newPasswordController.text == confirmPasswordController.text) {
      activeButtonCubit.changeStatus(true);
    } else {
      activeButtonCubit.changeStatus(false);
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: activeButtonCubit,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, loginstate) async {
          if (loginstate.changePasswordRequestSent) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const ResetPasswordSuccessDialog(),
            ).whenComplete(() => Navigator.of(context)
                .popUntil(ModalRoute.withName(LoginScreen.routeName)));
          }
        },
        builder: (context, loginstate) {
          return PopScope(
            canPop: willPopScope(!loginstate.changePasswordLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                onPop: () async =>
                    willPopScope(!loginstate.changePasswordLoading),
                title: Text(
                  tr(LocaleKeys.createNewPassword),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const AuthImageDescriptionWidget(
                                authDescriptionType:
                                    AuthDescriptionType.createPassword,
                              ),
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
                                    FilteringTextInputFormatter.deny(
                                        RegExp('[ ]')),
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
                                  onChanged: (_) {
                                    validateUpdatePasswordButton();
                                  },
                                );
                              }),
                              const SizedBox(height: 10),
                              const TextFieldHeadingTextWidget(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                text: 'Confirm New Password',
                                fontWeight: FontWeight.w500,
                              ),
                              StatefulBuilder(builder: (context, eyeState) {
                                return ThemeTextFormField(
                                  hint: "Enter Confirm New Password",
                                  controller: confirmPasswordController,
                                  style: const TextStyle(fontSize: 14),
                                  hintStyle: const TextStyle(fontSize: 14),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp('[ ]')),
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
                                      showReEnterPassword =
                                          !showReEnterPassword;
                                      eyeState(() {});
                                    },
                                  ),
                                  onChanged: (_) {
                                    validateUpdatePasswordButton();
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

                              const SizedBox(height: 10),
                              //Password Validator
                              PasswordValidatorWidget(
                                passwordController: newPasswordController,
                                onPasswordValidationChanged: (isPasswordValid) {
                                  this.isPasswordValid = isPasswordValid;
                                  validateUpdatePasswordButton();
                                },
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                          builder: (context, activeButtonState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ThemeElevatedButton(
                                  disableButton:
                                      !activeButtonState.activeNextButton,
                                  buttonName: tr(LocaleKeys.updatePassword),
                                  showLoadingSpinner:
                                      loginstate.changePasswordLoading,
                                  onPressed: () {
                                    //close the soft keyboard
                                    FocusScope.of(context).unfocus();
                                    if (!loginstate.changePasswordLoading &&
                                        formkey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                            ChangePassword(
                                              newPassword: newPasswordController
                                                  .text
                                                  .trim(),
                                              userName: widget.userName,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
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
