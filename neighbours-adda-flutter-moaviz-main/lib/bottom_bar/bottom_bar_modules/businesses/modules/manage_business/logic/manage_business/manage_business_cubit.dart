import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/repository/manage_business_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_business_state.dart';

class ManageBusinessCubit extends Cubit<ManageBusinessState> {
  final ManageBusinessRepository manageBusinessRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageBusinessCubit({
    required this.manageBusinessRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageBusinessState());

  ///This method can create and update the business
  Future<void> createOrUpdateBusinessDetails({
    required BusinessManageModel businessManageModel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.business,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        businessManageModel.media.addAll(mediaUploadResponse.mediaList);
      }

      //manage business api call
      await manageBusinessRepository.manageBusiness(
        businessManageModel: businessManageModel,
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

  ///Delete business
  Future<void> deleteBusiness(String businessId) async {
    try {
      emit(state.copyWith(isDeleteLoading: true));

      //manage business api call
      await manageBusinessRepository.deleteBusiness(businessId);

      emit(state.copyWith(isDeleteSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}
