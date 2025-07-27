import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'check_box_controller_state.dart';

class CheckBoxControllerCubit extends Cubit<CheckBoxControllerState> {
  final bool initialValue;
  CheckBoxControllerCubit({required this.initialValue})
      : super(CheckBoxControllerState(enable: initialValue));

  void toggle(bool status) {
    emit(state.copyWith(enable: status));
  }
}
