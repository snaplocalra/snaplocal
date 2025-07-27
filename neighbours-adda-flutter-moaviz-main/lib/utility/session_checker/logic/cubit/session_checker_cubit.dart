import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/session_checker/repository/session_checker_repository.dart';

part 'session_checker_state.dart';

class SessionCheckerCubit extends Cubit<SessionCheckerState> {
  final SessionCheckerRepository sessionCheckerRepository;
  SessionCheckerCubit(this.sessionCheckerRepository)
      : super(
          const SessionCheckerState(
            isLoading: true,
            isSessionValid: false,
          ),
        );

  Future<void> checkSession() async {
    try {
      emit(state.copyWith(isLoading: true));
      final isSessionValid = await sessionCheckerRepository.checkSession();
      emit(
        state.copyWith(
          isLoading: false,
          isSessionValid: isSessionValid,
        ),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(error: e.toString()));
    }
  }
}
