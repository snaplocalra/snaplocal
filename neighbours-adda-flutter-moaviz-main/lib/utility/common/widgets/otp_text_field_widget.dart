import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';

class OTPTextFieldWidget extends StatefulWidget {
  final void Function(String) onCompleted;
  final StreamController<ErrorAnimationType>? errorController;
  final String? Function(String?)? validator;
  const OTPTextFieldWidget({
    super.key,
    required this.onCompleted,
    this.errorController,
    this.validator,
  });
  @override
  State<OTPTextFieldWidget> createState() => _OTPTextFieldWidgetState();
}

class _OTPTextFieldWidgetState extends State<OTPTextFieldWidget> {
  int otpTextFieldCount = 4;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: otpTextFieldCount,
      obscureText: false,
      enableActiveFill: true,
      blinkWhenObscuring: true,
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      errorAnimationController: widget.errorController,
      keyboardType: TextInputType.number,
      pastedTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      useHapticFeedback: true,
      enablePinAutofill: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 65,
        fieldWidth: 65,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Colors.transparent,
        inactiveColor: Colors.black45,
        inactiveFillColor: Colors.transparent,
        selectedColor: Colors.black45,
        selectedFillColor: Colors.transparent,
      ),
      validator: widget.validator,
      onCompleted: ((value) {
        context.read<ActiveButtonCubit>().changeStatus(true);
        widget.onCompleted.call(value);
      }),
      onSaved: (value) {},
      onChanged: (value) {
        if (value.length < otpTextFieldCount) {
          context.read<ActiveButtonCubit>().changeStatus(false);
        }
      },
      beforeTextPaste: (text) {
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        HapticFeedback.lightImpact();
        return true;
      },
    );
  }
}
