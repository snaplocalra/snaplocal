import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_visibility/bottom_bar_visibility_cubit.dart';

part 'bottom_bar_navigator_state.dart';

class BottomBarNavigatorCubit extends Cubit<BottomBarNavigatorState> {
  final BottomBarVisibilityCubit barVisibilityCubit;
  BottomBarNavigatorCubit(this.barVisibilityCubit)
      : super(const BottomBarNavigatorState(currentSelectedScreenIndex: 0));

  void goToHome() {
    emit(state.copyWith(currentSelectedScreenIndex: 0));
  }

  void changeScreen({required int selectedIndex}) {
    emit(state.copyWith(isLoading: true));
    barVisibilityCubit.showBottomBar();
    emit(state.copyWith(currentSelectedScreenIndex: selectedIndex));
  }
}
