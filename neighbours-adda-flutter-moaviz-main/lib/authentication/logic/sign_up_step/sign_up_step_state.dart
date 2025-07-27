// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_step_cubit.dart';

enum StepEnum { step1, step2 }

class SignUpStepState extends Equatable {
  final StepEnum stepEnum;
  const SignUpStepState({
    this.stepEnum = StepEnum.step1,
  });

  @override
  List<Object> get props => [stepEnum];

  SignUpStepState copyWith({
    StepEnum? stepEnum,
  }) {
    return SignUpStepState(
      stepEnum: stepEnum ?? this.stepEnum,
    );
  }
}
