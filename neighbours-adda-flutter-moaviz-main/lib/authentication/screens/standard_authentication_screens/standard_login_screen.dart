import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/forgot_password_screen.dart.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/verify_otp_screen.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/local_storage/flutter_secure_storage.dart';
import 'package:snap_local/utility/local_storage/model/storage_keys_enum.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class LoginScreen extends StatefulWidget {
  final String userName;
  final String userDisplayName;

  const LoginScreen({
    super.key,
    required this.userName,
    required this.userDisplayName,
  });

  static const routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final activeButtonState = ActiveButtonCubit();

  bool showPassword = false;

  void prefillCreds() {
    final credsLocalStorage = FlutterSecureStorageImpl();

    //Prefill the username
    // credsLocalStorage.getKey(StorageKey.userName).then((value) {
    //   if (value != null) {
    //     usernameTextController.text = value;
    //   }
    // });
    usernameTextController.text = widget.userName;

    //Prefill the password
    credsLocalStorage.getKey(StorageKey.password).then((value) {
      if (value != null) {
        passwordTextController.text = value;
      }
    });
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    prefillCreds();
  }

  void validateLoginButtonEnableState() {
    if (usernameTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      activeButtonState.changeStatus(true);
    } else if (usernameTextController.text.isEmpty) {
      activeButtonState.changeStatus(false);
    } else if (passwordTextController.text.isEmpty) {
      activeButtonState.changeStatus(false);
    }
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final isTelugu =
        EasyLocalization.of(context)!.currentLocale == LocaleManager.telugu;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, loginState) {
        if (loginState.loginCompleted) {
          if (loginState.otpVerified) {
            //This user verified the username by OTP verification
            //redirect to 1st route
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            GoRouter.of(context)
                .pushNamed(VerifyOTPScreen.routeName, queryParameters: {
              "username": usernameTextController.text.trim(),
            });
          }
          //
        }
        return;
      },
      builder: (context, loginState) {
        return PopScope(
          canPop: willPopScope(!loginState.loginLoading),
          child: Scaffold(
            appBar: ThemeAppBar(
              onPop: () async => willPopScope(!loginState.loginLoading),
              title: Text(
                tr(LocaleKeys.login),
                style: TextStyle(color: ApplicationColours.themeBlueColor),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: mqSize.height * 0.02),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formkey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(children: [
                              SvgPicture.asset(
                                isTelugu
                                    ? SVGAssetsImages.welcomeTelugu
                                    : SVGAssetsImages.welcome,
                                height: 100,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tr(LocaleKeys.back),
                                    style: GoogleFonts.greatVibes(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      color: ApplicationColours.themePinkColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${widget.userDisplayName}!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ApplicationColours.themeBlueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 5),
                            Text(
                              tr(LocaleKeys.enterYourPasswordToContinue),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            TextFieldHeadingTextWidget(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              text: tr(LocaleKeys.password),
                              showStarMark: true,
                              fontWeight: FontWeight.w500,
                            ),
                            StatefulBuilder(builder: (context, eyeState) {
                              return ThemeTextFormField(
                                key: const Key("password"),
                                controller: passwordTextController,
                                hint: tr(LocaleKeys.enterPassword),
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
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    showPassword = !showPassword;
                                    eyeState(() {});
                                  },
                                ),
                                onChanged: (_) {
                                  validateLoginButtonEnableState();
                                },
                                validator: (text) => TextFieldValidator
                                    .standardValidatorWithMinLength(
                                  text,
                                  TextFieldInputLength.passwordMinLength,
                                ),
                              );
                            }),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  GoRouter.of(context).pushNamed(
                                    ForgotPasswordScreen.routeName,
                                    queryParameters: {
                                      "username":
                                          usernameTextController.text.trim(),
                                    },
                                  );
                                },
                                child: Text(
                                  tr(LocaleKeys.forgotPassword),
                                  style: TextStyle(
                                    color:
                                        ApplicationColours.themeLightPinkColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, loginState) {
                          return ThemeElevatedButton(
                            key: const Key("login_button"),
                            showLoadingSpinner: loginState.loginLoading,
                            buttonName: tr(LocaleKeys.login),
                            textFontSize: 16,
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();

                                context.read<LoginBloc>().add(
                                      LogInUser(
                                        userName:
                                            usernameTextController.text.trim(),
                                        password:
                                            passwordTextController.text.trim(),
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
