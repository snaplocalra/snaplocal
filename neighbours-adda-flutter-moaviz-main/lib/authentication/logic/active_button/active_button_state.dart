part of 'active_button_cubit.dart';

class ActiveButtonState extends Equatable {
  final bool activeNextButton;
  const ActiveButtonState({this.activeNextButton = false});

  @override
  List<Object> get props => [activeNextButton];

  ActiveButtonState copyWith({
    required bool activeNextButton,
  }) {
    return ActiveButtonState(
      activeNextButton: activeNextButton,
    );
  }
}
