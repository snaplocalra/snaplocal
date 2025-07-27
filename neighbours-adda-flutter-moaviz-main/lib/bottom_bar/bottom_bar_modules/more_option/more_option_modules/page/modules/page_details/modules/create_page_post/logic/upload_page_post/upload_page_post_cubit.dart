import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/models/manage_page_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/repository/manage_page_post_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'upload_page_post_state.dart';

class UploadPagePostCubit extends Cubit<UploadPagePostState> {
  final ManagePagePostRepository createPagePostRepository;
  final MediaUploadRepository mediaUploadRepository;

  UploadPagePostCubit({
    required this.createPagePostRepository,
    required this.mediaUploadRepository,
  }) : super(const UploadPagePostState());

  Future<void> managePost({
    required UploadPagePostModel uploadPagePostModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.page,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        uploadPagePostModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await createPagePostRepository.updatePagePost(
            updatedPagePostModel: uploadPagePostModel);
      } else {
        await createPagePostRepository.uploadPagePost(
            uploadPagePostModel: uploadPagePostModel);
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
