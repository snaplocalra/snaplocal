import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_jobs/local_jobs_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalJobsCubit extends Cubit<LocalJobsState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;

  LocalJobsCubit(
    this.homeDataRepository,
  ) : super(
          const LocalJobsState(
            dataLoading: true,
            jobs: [],
          ),
        );

  Future<void> fetchLocalJobs() async {
    try {
      if (state.jobs.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final response = await homeDataRepository.fetchLocalJobs();
      emit(state.copyWith(
        jobs: response.data,
        dataLoading: false,
      ));
      return;
    } catch (e) {
      print(e.toString());
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.jobs.isEmpty) {
        emit(state.copyWith(
          error: e.toString(),
          dataLoading: false,
        ));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  @override
  LocalJobsState? fromJson(Map<String, dynamic> json) {
    return LocalJobsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalJobsState state) {
    return state.toMap();
  }
} 