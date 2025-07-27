part of 'active_button_cubit.dart';

class ActiveButtonState extends Equatable {
  final bool isEnabled;
  const ActiveButtonState({this.isEnabled = false});

  @override
  List<Object> get props => [isEnabled];

  ActiveButtonState copyWith({
    bool? isEnabled,
  }) {
    return ActiveButtonState(
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
