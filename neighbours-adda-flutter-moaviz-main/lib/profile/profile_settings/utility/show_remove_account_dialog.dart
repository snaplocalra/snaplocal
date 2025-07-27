import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/profile_settings/logic/remove_account/remove_account_cubit.dart';
import 'package:snap_local/profile/profile_settings/widgets/remove_account_dialog.dart';
import 'package:snap_local/utility/common/widgets/otp_verification_dialog.dart';

Future<void> showRemoveAccountDialog(BuildContext context,
    {required String phoneNumber}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return BlocConsumer<RemoveAccountCubit, RemoveAccountState>(
        listener: (context, removeAccountState) {
          if (removeAccountState.otpVerificationCompleted) {
            GoRouter.of(context).pop();
          }
        },
        builder: (context, removeAccountState) {
          return PopScope(
            canPop: !removeAccountState.isLoading,
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: removeAccountState.openVerifyOTPWidget
                  ? OTPVerificationDialog(
                      verifyOTPLoading: removeAccountState.verifyOTPLoading,
                      otpVerificationFailed:
                          removeAccountState.otpVerificationFailed,
                      phoneNumber: phoneNumber,
                      onResendOTP: () {
                        context
                            .read<RemoveAccountCubit>()
                            .resendOTP(phoneNumber: phoneNumber);
                      },
                      onOTPSubmit: (String otp) {
                        context.read<RemoveAccountCubit>().verifyOTP(otp: otp);
                      },
                    )
                  : const RemoveAccountDialog(),
            ),
          );
        },
      );
    },
  );
}
