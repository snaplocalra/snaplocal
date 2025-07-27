import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/onboarding/model/on_boarding_model.dart';
import 'package:snap_local/onboarding/repository/on_boarding_repository.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final OnBoardingRepository onBoardingRepository;
  OnBoardingCubit(this.onBoardingRepository)
      : super(LoadingOnBoardingDetails());

  Future<void> fetchOnboardingScreenDetails() async {
    try {
      emit(LoadingOnBoardingDetails());
      final onBoardingScreens =
          await onBoardingRepository.fetchOnBoardingData();
      emit(OnBoardingDetailsFetched(onBoardingScreens: onBoardingScreens));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(OnBoardingError(error: e.toString()));
    }
  }
}
