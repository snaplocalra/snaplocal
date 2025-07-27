import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:snap_local/authentication/logic/resend_code_button/resend_code_button_cubit.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/resend_button_widget.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/widgets/otp_text_field_widget.dart';
import 'package:timer_count_down/timer_controller.dart';

class OTPVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final bool verifyOTPLoading;
  final bool otpVerificationFailed;
  final void Function(String otp) onOTPSubmit;
  final void Function() onResendOTP;
  const OTPVerificationDialog({
    super.key,
    required this.phoneNumber,
    this.verifyOTPLoading = false,
    this.otpVerificationFailed = false,
    required this.onOTPSubmit,
    required this.onResendOTP,
  });

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
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

  void checkOTPError() {
    if (widget.otpVerificationFailed) {
      errorController.add(ErrorAnimationType.shake);
    }
  }

  @override
  void didUpdateWidget(covariant OTPVerificationDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      checkOTPError();
    }
  }

  @override
  void dispose() {
    super.dispose();
    otpTextController.dispose();
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
      child: Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  tr(LocaleKeys.verifyOtpToConfirm),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(5, 18, 66, 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 10),
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
                        widget.phoneNumber,
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: OTPTextFieldWidget(
                    key: const Key("otp_text_field"),
                    errorController: errorController,
                    onCompleted: (otp) {
                      otpTextController.text = otp.trim();
                      widget.onOTPSubmit(otpTextController.text);

                      context.read<ActiveButtonCubit>().changeStatus(true);
                    },
                  ),
                ),
                BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                  builder: (context, state) {
                    return ThemeElevatedButton(
                      key: const Key("verify_otp"),
                      buttonName: tr(LocaleKeys.verifyNow),
                      textFontSize: 18,
                      disableButton: !state.isEnabled,
                      showLoadingSpinner: widget.verifyOTPLoading,
                      onPressed: () {
                        //close the soft keyboard
                        FocusScope.of(context).unfocus();
                        if (!widget.verifyOTPLoading) {
                          widget.onOTPSubmit(otpTextController.text);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                ResendButtonWidget(
                  controller: resendOTPcontroller,
                  phoneNumber: widget.phoneNumber,
                  onResend: () {
                    ThemeToast.successToast(
                        "Sending OTP to ${widget.phoneNumber}");
                    //Hide otp resend button
                    context
                        .read<ResendCodeButtonCubit>()
                        .showResendButton(false);
                    widget.onResendOTP();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
