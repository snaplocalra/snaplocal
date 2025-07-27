// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/widgets/show_snak_bar.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/logic/resend_code_button/resend_code_button_cubit.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/change_password_screen.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/resend_button_widget.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/widgets/otp_text_field_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:timer_count_down/timer_controller.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String userName;
  final bool isForgetPassword;

  const VerifyOTPScreen({
    super.key,
    required this.userName,
    this.isForgetPassword = false,
  });

  static const routeName = 'verify_otp';

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final otpTextController = TextEditingController();
  final activeVerifyButtonCubit = ActiveButtonCubit();
  late StreamController<ErrorAnimationType> errorController;
  final CountdownController resendOTPcontroller =
      CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    activeVerifyButtonCubit.changeStatus(false);
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  void dispose() {
    otpTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: activeVerifyButtonCubit,
        ),
        BlocProvider(create: (context) => ResendCodeButtonCubit()),
      ],
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, loginstate) {
          if (loginstate.otpVerified) {
            if (widget.isForgetPassword) {
              GoRouter.of(context)
                  .pushNamed(ChangePasswordScreen.routeName, queryParameters: {
                'username': widget.userName,
              });
            } else {
              //pop all the screen and go to root screen
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } else if (loginstate.otpResent) {
            context.read<ResendCodeButtonCubit>().showResendButton(
                false); //disbale the tr(LocaleKeys.resend) button
            resendOTPcontroller.start(); //start the counter
          } else if (loginstate.failedOTPVerification) {
            errorController.add(ErrorAnimationType.shake);
          }
        },
        builder: (context, loginstate) {
          return PopScope(
            canPop: willPopScope(!loginstate.verifyOTPLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                onPop: () async => willPopScope(!loginstate.verifyOTPLoading),
                title: Text(
                  tr(LocaleKeys.otpVerification),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
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
                            SvgPicture.asset(
                              SVGAssetsImages.otpVerification,
                              height: 250,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, bottom: 10),
                              child: Column(
                                children: [
                                  Text(
                                    tr(LocaleKeys.pleaseEnterOtpSentTo),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(5, 18, 66, 0.53),
                                      height: 1.5,
                                    ),
                                  ),
                                  Text(
                                    widget.userName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(5, 18, 66, 1),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: OTPTextFieldWidget(
                                key: const Key("otp_text_field"),
                                errorController: errorController,
                                onCompleted: (otp) {
                                  otpTextController.text = otp.trim();
                                  context.read<LoginBloc>().add(
                                        VerifyOTP(
                                          otp: otpTextController.text,
                                          userName: widget.userName,
                                          isForgotPassword:
                                              widget.isForgetPassword,
                                        ),
                                      );
                                  context
                                      .read<ActiveButtonCubit>()
                                      .changeStatus(true);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ResendButtonWidget(
                          controller: resendOTPcontroller,
                          phoneNumber: widget.userName,
                          onResend: () {
                            ShowSnackBar.showSnackBar(
                              context,
                              "Sending OTP to ${widget.userName}",
                              second: 2,
                            );
                            context.read<LoginBloc>().add(ResendOTP(
                                  userName: widget.userName,
                                  isForgotPassword: widget.isForgetPassword,
                                ));
                          },
                        ),
                      ),
                      BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                        builder: (context, state) {
                          return ThemeElevatedButton(
                            key: const Key("confirm"),
                            buttonName: (tr(LocaleKeys.confirm)),
                            textFontSize: 18,
                            disableButton: !state.isEnabled,
                            showLoadingSpinner: loginstate.verifyOTPLoading,
                            onPressed: () {
                              //close the soft keyboard
                              FocusScope.of(context).unfocus();
                              if (!loginstate.verifyOTPLoading) {
                                context.read<LoginBloc>().add(
                                      VerifyOTP(
                                        otp: otpTextController.text,
                                        userName: widget.userName,
                                        isForgotPassword:
                                            widget.isForgetPassword,
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
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
