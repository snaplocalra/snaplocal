import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/logic/user_name_text_field_controller/user_name_text_field_controller_cubit.dart';
import 'package:snap_local/authentication/models/auth_description_type.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/verify_otp_screen.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/auth_image_description_widget.dart';
import 'package:snap_local/authentication/widgets/user_name_text_field.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String preSelectedUserName;
  const ForgotPasswordScreen({
    super.key,
    required this.preSelectedUserName,
  });

  static const routeName = 'forgot_password';
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.preSelectedUserName;
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserNameTextFieldControllerCubit(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, loginstate) {
          if (loginstate.forgotPasswordRequestSent) {
            GoRouter.of(context).pushNamed(
              VerifyOTPScreen.routeName,
              queryParameters: {
                'username': userNameController.text.trim(),
                'is_forgot_password': true.toString(),
              },
            );
          }
        },
        builder: (context, loginstate) {
          return PopScope(
            canPop: willPopScope(!loginstate.sendOTPLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                onPop: () async => willPopScope(!loginstate.sendOTPLoading),
                title: Text(
                  tr(LocaleKeys.forgotYourPassword),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                  AuthDescriptionType.forgotPassword,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 25,
                              ),
                              child: UserNameTextField(
                                userNameController: userNameController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<UserNameTextFieldControllerCubit,
                          UserNameTextFieldControllerState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ThemeElevatedButton(
                                buttonName: tr(LocaleKeys.continueButton),
                                showLoadingSpinner: loginstate.sendOTPLoading,
                                onPressed: () {
                                  //close the soft keyboard
                                  FocusScope.of(context).unfocus();
                                  String? error;
                                  if (userNameController.text.trim().isEmpty) {
                                    error = tr(LocaleKeys
                                        .pleaseEnterYourPhoneNumberOrEmail);
                                  } else if (state is PhoneTextField) {
                                    error =
                                        TextFieldValidator.phoneNumberValidator(
                                            userNameController.text.trim());
                                  } else if (state is EmailTextField) {
                                    error = TextFieldValidator.emailValidator(
                                        userNameController.text.trim());
                                  }

                                  if (error != null) {
                                    ThemeToast.errorToast(error);
                                    return;
                                  } else if (!loginstate.sendOTPLoading) {
                                    context.read<LoginBloc>().add(
                                          ForgotPassword(
                                            userName:
                                                userNameController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      )
                    ],
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
