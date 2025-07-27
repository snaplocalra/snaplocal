part of 'check_box_controller_cubit.dart';

class CheckBoxControllerState extends Equatable {
  final bool enable;
  const CheckBoxControllerState({this.enable = false});

  @override
  List<Object> get props => [enable];

  CheckBoxControllerState copyWith({bool? enable}) {
    return CheckBoxControllerState(enable: enable ?? false);
  }
}
