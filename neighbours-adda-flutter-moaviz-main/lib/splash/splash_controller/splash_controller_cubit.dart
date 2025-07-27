import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'splash_controller_state.dart';

class SplashControllerCubit extends Cubit<SplashControllerState> {
  SplashControllerCubit() : super(const SplashControllerState()) {
    checkSplashStatus();
  }

  // Future<void> checkSplashStatus() async {
  //   final splashPref = SplashSharedPref();
  //   emit(state.copyWith(loadSplash: true));
  //   final isRegularOpen = await splashPref.isRegularOpen();
  //   showSplash(isRegularOpen);

  //   int timerSeconds = isRegularOpen ? 2 : 12;
  //   Future.delayed(Duration(seconds: timerSeconds), () {
  //     closeSplash();
  //   });

  //   if (!isRegularOpen) {
  //     //For the fresh open set it as completed
  //     splashPref.setFreshOpenCompleted();
  //   }
  // }

  Future<void> checkSplashStatus() async {
    emit(state.copyWith(loadSplash: true));
    showSplash(true);
    int timerSeconds = 2;
    Future.delayed(Duration(seconds: timerSeconds), () {
      closeSplash();
    });
  }

  void showSplash(bool isRegularOpen) {
    emit(state.copyWith(showSplash: true, isRegularOpen: isRegularOpen));
  }

  void closeSplash() {
    emit(state.copyWith());
  }
}
