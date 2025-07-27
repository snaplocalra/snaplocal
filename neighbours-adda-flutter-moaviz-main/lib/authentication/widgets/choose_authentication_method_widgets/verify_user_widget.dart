// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/logic/user_name_text_field_controller/user_name_text_field_controller_cubit.dart';
import 'package:snap_local/authentication/models/signup_screen_payload.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/signup_screen.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/standard_login_screen.dart';
import 'package:snap_local/authentication/widgets/user_name_text_field.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class VerifyUserWidget extends StatefulWidget {
  const VerifyUserWidget({super.key});

  @override
  State<VerifyUserWidget> createState() => _VerifyPhoneWidgetState();
}

class _VerifyPhoneWidgetState extends State<VerifyUserWidget> {
  final userNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserNameTextFieldControllerCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              tr(LocaleKeys.getStarted),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(5, 18, 66, 1),
              ),
            ),
          ),
          UserNameTextField(userNameController: userNameController),
          const SizedBox(height: 15),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, loginState) {
              if (loginState.userCheckModel != null) {
                if (loginState.userCheckModel!.isUserRegistered) {
                  GoRouter.of(context).pushNamed(
                    LoginScreen.routeName,
                    queryParameters: {
                      "username": userNameController.text.trim(),
                      "user_display_name":
                          loginState.userCheckModel!.userDisplayName,
                    },
                  );
                } else {
                  GoRouter.of(context).pushNamed(
                    SignupScreen.routeName,
                    extra: StandardLoginPayload(
                      userName: userNameController.text.trim(),
                    ),
                  );
                }
              }
            },
            builder: (context, loginState) {
              return BlocBuilder<UserNameTextFieldControllerCubit,
                  UserNameTextFieldControllerState>(
                builder: (context, state) {
                  return BlocBuilder<SocialLoginBloc, SocialLoginState>(
                    builder: (context, socialLoginState) {
                      return ThemeElevatedButton(
                        key: const Key("continue"),
                        buttonName: tr(LocaleKeys.continueButton),
                        disableButton: socialLoginState.requestLoading,
                        showLoadingSpinner: loginState.phoneVerifyLoading,
                        onPressed: () {
                          String? error;
                          if (userNameController.text.trim().isEmpty) {
                            error = tr(
                                LocaleKeys.pleaseEnterYourPhoneNumberOrEmail);
                          } else if (state is PhoneTextField) {
                            error = TextFieldValidator.phoneNumberValidator(
                                userNameController.text.trim());
                          } else if (state is EmailTextField) {
                            error = TextFieldValidator.emailValidator(
                                userNameController.text.trim());
                          }

                          if (error != null) {
                            ThemeToast.errorToast(error);
                            return;
                          } else {
                            FocusScope.of(context).unfocus();
                            context.read<LoginBloc>().add(VerifyUserName(
                                  userName: userNameController.text.trim(),
                                ));
                            return;
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
