// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/models/register_user_model.dart';
import 'package:snap_local/authentication/models/signup_screen_payload.dart';
import 'package:snap_local/authentication/models/social_login_user_profile_register_model.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/verify_otp_screen.dart';
import 'package:snap_local/authentication/widgets/choose_authentication_method_widgets/agreement_widget.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/account_safe_message_widget.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/signup_steps_widget.dart';
import 'package:snap_local/common/social_media/profile/gender/logic/gender_selector/gender_selector_cubit.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SignupScreen extends StatefulWidget {
  final SignupScreenPayload payLoad;
  const SignupScreen({super.key, required this.payLoad});

  static const routeName = 'signup';

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  //year of birth
  int? yearOfBirth;

  GenderSelectorCubit genderSelectorCubit = GenderSelectorCubit();
  GenderEnum gender = GenderEnum.male;

  //Active button cubit
  final activeButtonCubit = ActiveButtonCubit();

  // If the user is signing up with apple login, then hide the password field
  late bool hidePasswordField = (widget.payLoad is SocialLoginPayload &&
      (widget.payLoad as SocialLoginPayload).loginEvent is AppleLogin);

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.payLoad is SocialLoginUserData) {
      final socialLogin = widget.payLoad as SocialLoginUserData;
      if (socialLogin.displayName != null) {
        nameController.text = socialLogin.displayName!;
      }
    }
    userNameController.text = widget.payLoad.userName;

    //Clear the selected language
    context.read<LanguageKnownCubit>().clearSelection();

    //Preselect the gender
    genderSelectorCubit.selectGender(gender);
  }

  void _registerUser() {
    //Standard registration
    late RegisterUserModel registerUserModel;

    if (widget.payLoad is StandardLoginPayload) {
      registerUserModel = RegisterUserModel(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        dateOfBirth: yearOfBirth == null ? null : DateTime(yearOfBirth!),
        gender: gender.name,
        password: passwordController.text.trim(),
      );
    } else if (widget.payLoad is SocialLoginPayload) {
      registerUserModel = SocialLoginUserRegisterModel(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        dateOfBirth: yearOfBirth == null ? null : DateTime(yearOfBirth!),
        gender: gender.name,
        password: passwordController.text.trim(),
        socialLoginId: (widget.payLoad as SocialLoginPayload).user.uid,
      );
    } else {
      throw Exception(tr(LocaleKeys.invalidRegistrationType));
    }

    // Call the registerUser event
    context.read<LoginBloc>().add(
          RegisterUser(
            registerUserModel: registerUserModel,
            registrationType: widget.payLoad.registrationType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: genderSelectorCubit),
        BlocProvider.value(value: activeButtonCubit),
      ],
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, loginstate) {
          if (loginstate.socialLoginVerified) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (loginstate.signupCompleted) {
            GoRouter.of(context)
                .pushNamed(VerifyOTPScreen.routeName, queryParameters: {
              "username": userNameController.text.trim(),
            });
          }
        },
        builder: (context, loginstate) {
          return PopScope(
            canPop: willPopScope(!loginstate.signupLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                onPop: () async => willPopScope(!loginstate.signupLoading),
                title: Text(
                  tr(LocaleKeys.signup),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Step1Widgets(
                            nameController: nameController,
                            onDOBSelected: (birthYear) {
                              yearOfBirth = birthYear;
                            },
                            onGenderSelected: (GenderEnum selectedGender) {
                              gender = selectedGender;
                              context
                                  .read<GenderSelectorCubit>()
                                  .selectGender(selectedGender);
                            },
                          ),
                          if (!hidePasswordField)
                            //Password field
                            Builder(
                              builder: (context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Step2Widgets(
                                      passwordController: passwordController,
                                      onPasswordValidationChanged:
                                          (isPasswordValid) {
                                        context
                                            .read<ActiveButtonCubit>()
                                            .changeStatus(isPasswordValid);
                                      },
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 25, 10, 5),
                                      child: AgreementWidget(
                                        agreemenFrom: AgreemenFrom.signupScreen,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AccountSafeMessageWidget(),
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, loginstate) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ThemeElevatedButton(
                            buttonName: tr(LocaleKeys.continueButton),
                            showLoadingSpinner: loginstate.signupLoading,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (!loginstate.sendOTPLoading &&
                                  formkey.currentState!.validate()) {
                                // if (yearOfBirth == null ) {
                                //   ThemeToast.errorToast(
                                //       "Please select your year of birth");
                                //   return;
                                // }

                                _registerUser();
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
          );
        },
      ),
    );
  }
}
