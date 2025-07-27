part of 'resend_code_button_cubit.dart';

class ResendCodeButtonState extends Equatable {
  final bool showResendButton;
  const ResendCodeButtonState({this.showResendButton = false});

  @override
  List<Object> get props => [showResendButton];

  ResendCodeButtonState copyWith({
    required bool showResendButton,
  }) {
    return ResendCodeButtonState(
      showResendButton: showResendButton,
    );
  }
}
