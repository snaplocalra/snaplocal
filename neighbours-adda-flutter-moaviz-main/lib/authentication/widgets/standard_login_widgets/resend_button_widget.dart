import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/resend_code_button/resend_code_button_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ResendButtonWidget extends StatefulWidget {
  final String phoneNumber;
  final int otpResendTimer;
  final CountdownController controller;
  final void Function()? onResend;
  const ResendButtonWidget({
    super.key,
    required this.controller,
    required this.phoneNumber,
    this.otpResendTimer = 30,
    required this.onResend,
  });

  @override
  State<ResendButtonWidget> createState() => _ResendButtonWidgetState();
}

class _ResendButtonWidgetState extends State<ResendButtonWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ResendCodeButtonCubit>().showResendButton(false);
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ResendCodeButtonCubit, ResendCodeButtonState>(
        builder: (context, state) {
          if (state.showResendButton) {
            return Column(
              children: [
                Text(
                  tr(LocaleKeys.didntReceiveACode),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(5, 18, 66, 1),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (widget.onResend != null) {
                      widget.onResend!.call();
                    }
                  },
                  child: Text(
                    tr(LocaleKeys.resend),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${tr(LocaleKeys.resendCodeIn)} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromRGBO(5, 18, 66, 1),
                      ),
                    ),
                    Countdown(
                      controller: widget.controller,
                      seconds: widget.otpResendTimer,
                      build: (_, double time) => Text(
                        "0:${time.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      interval: const Duration(milliseconds: 100),
                      onFinished: () {
                        FocusScope.of(context).unfocus();
                        context
                            .read<ResendCodeButtonCubit>()
                            .showResendButton(true);
                      },
                    )
                  ],
                ),
              ],
            );
          }
        },
      );
}
