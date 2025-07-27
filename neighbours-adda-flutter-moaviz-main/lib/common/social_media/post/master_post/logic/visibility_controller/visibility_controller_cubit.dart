import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'visibility_controller_state.dart';

class VisibilityControllerCubit extends Cubit<VisibilityControllerState> {
  VisibilityControllerCubit() : super(const VisibilityControllerState());

  void changeVisibility(bool visible) {
    emit(state.copyWith(isVisible: visible));
  }
}
