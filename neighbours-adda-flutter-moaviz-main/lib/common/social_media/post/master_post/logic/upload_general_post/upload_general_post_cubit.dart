// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/lost_found_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/regular_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/safety_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/repository/manage_general_post_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'upload_general_post_state.dart';

class UploadGeneralPostCubit extends Cubit<UploadGeneralPostState> {
  final ManageGeneralPostRepository manageGeneralPostRepository;
  final MediaUploadRepository mediaUploadRepository;

  UploadGeneralPostCubit({
    required this.manageGeneralPostRepository,
    required this.mediaUploadRepository,
  }) : super(const UploadGeneralPostState());

  Future<void> manageRegularPost({
    required RegularDataPostModel regularDataPostModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.post,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        regularDataPostModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await manageGeneralPostRepository.updateRegularPost(
          regularDataPostModel: regularDataPostModel,
        );
      } else {
        await manageGeneralPostRepository.uploadRegularPost(
          regularDataPostModel: regularDataPostModel,
        );
      }

      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> manageLostFoundPost({
    required LostFoundDataPostModel lostFoundDataPostModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.post,
          mediaList: pickedMediaList,
        );
        //Add the server response image list in the data model
        lostFoundDataPostModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await manageGeneralPostRepository.updateLostFoundPost(
          lostFoundDataPostModel: lostFoundDataPostModel,
        );
      } else {
        await manageGeneralPostRepository.uploadLostFoundPost(
          lostFoundDataPostModel: lostFoundDataPostModel,
        );
      }

      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> manageSafetyPost({
    required SafetyDataPostModel safetyDataPostModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.post,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        safetyDataPostModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await manageGeneralPostRepository.updateSafetyPost(safetyDataPostModel);
      } else {
        await manageGeneralPostRepository.uploadSafetyPost(
          safetyDataPostModel: safetyDataPostModel,
        );
      }

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
