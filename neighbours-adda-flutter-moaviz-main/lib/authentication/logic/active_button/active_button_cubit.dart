import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'active_button_state.dart';

class ActiveButtonCubit extends Cubit<ActiveButtonState> {
  ActiveButtonCubit() : super(const ActiveButtonState());

  Future<void> changeStatus(bool activeNextButton) async {
    emit(state.copyWith(activeNextButton: activeNextButton));
  }
}
