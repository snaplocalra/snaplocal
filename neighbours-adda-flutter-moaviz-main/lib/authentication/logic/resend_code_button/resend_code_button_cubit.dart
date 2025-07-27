import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'resend_code_button_state.dart';

class ResendCodeButtonCubit extends Cubit<ResendCodeButtonState> {
  ResendCodeButtonCubit() : super(const ResendCodeButtonState());

  Future<void> showResendButton(bool newStatusRequest) async {
    emit(state.copyWith(showResendButton: newStatusRequest));
    return;
  }
}
