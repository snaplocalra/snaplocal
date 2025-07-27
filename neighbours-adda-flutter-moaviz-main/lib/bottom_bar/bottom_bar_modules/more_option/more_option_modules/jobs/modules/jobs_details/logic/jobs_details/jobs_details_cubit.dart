import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/repository/jobs_details_repository.dart';

part 'jobs_details_state.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobsDetailsRepository jobsDetailsRepository;
  JobDetailsCubit(this.jobsDetailsRepository) : super(const JobDetailsState());

  Future<void> fetchJobDetails({required String jobId}) async {
    try {
      if (state.error != null || !state.isJobDetailAvailable) {
        emit(state.copyWith(dataLoading: true));
      }
      final jobDetails =
          await jobsDetailsRepository.fetchJobsDetails(jobId: jobId);
      emit(state.copyWith(jobDetailModel: jobDetails));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updatePostSaveStatus(bool newStatus) {
    if (state.jobDetailModel != null) {
      emit(state.copyWith(dataLoading: true));
      emit(state.copyWith(
        jobDetailModel: state.jobDetailModel!.copyWith(isSaved: newStatus),
      ));
    }
    return;
  }

  //Application submit 
  Future<void> applyJob({required String jobId}) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await jobsDetailsRepository.applyJob(jobId: jobId);
      await fetchJobDetails(jobId: jobId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(requestLoading: false));
    }
  }

  //Position close
  Future<void> closePosition({required String jobId}) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await jobsDetailsRepository.closePosition(jobId: jobId);
      await fetchJobDetails(jobId: jobId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(requestLoading: false));
    }
  }
}
