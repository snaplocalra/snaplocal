import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_step_state.dart';

class SignUpStepCubit extends Cubit<SignUpStepState> {
  SignUpStepCubit() : super(const SignUpStepState());

  void changeStep(StepEnum stepEnum) {
    emit(state.copyWith(stepEnum: stepEnum));
  }
}
