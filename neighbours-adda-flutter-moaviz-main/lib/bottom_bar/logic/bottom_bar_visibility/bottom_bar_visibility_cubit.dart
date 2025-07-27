import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_bar_visibility_state.dart';

class BottomBarVisibilityCubit extends Cubit<BottomBarVisibilityState> {
  BottomBarVisibilityCubit() : super(const BottomBarVisibilityState());

  void showBottomBar() {
    emit(state.copyWith(visible: true));
  }

  void hideBottomBar() {
    emit(state.copyWith(visible: false));
  }
}
