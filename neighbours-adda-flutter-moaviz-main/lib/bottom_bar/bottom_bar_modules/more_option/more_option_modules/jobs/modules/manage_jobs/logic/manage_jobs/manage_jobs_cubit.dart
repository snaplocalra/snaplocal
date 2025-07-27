import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/models/jobs_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/repository/manage_jobs_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_jobs_state.dart';

class ManageJobsCubit extends Cubit<ManageJobsState> {
  final ManageJobRepository manageJobRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageJobsCubit({
    required this.manageJobRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageJobsState());

  ///This method can create and update the Job
  Future<void> createOrUpdateJobs({
    required JobManageModel jobManageModel,
    required MediaFileModel? pickedMedia,

    //Edit mode
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMedia != null) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.job,
          mediaList: [pickedMedia],
        );

        //Add the server response image list in the data model
        jobManageModel.media.addAll(mediaUploadResponse.mediaList);
      }

      //manage Job post api call
      await manageJobRepository.manageJob(
        jobManageModel: jobManageModel,
        isEdit: isEdit,
      );

      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}
