import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/models/manage_group_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/repository/manage_group_post_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'upload_group_post_state.dart';

class UploadGroupPostCubit extends Cubit<UploadGroupPostState> {
  final ManageGroupPostRepository createGroupPostRepository;
  final MediaUploadRepository mediaUploadRepository;

  UploadGroupPostCubit({
    required this.createGroupPostRepository,
    required this.mediaUploadRepository,
  }) : super(const UploadGroupPostState());

  Future<void> managePost({
    required ManageGroupPostModel uploadGroupPostModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.group,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        uploadGroupPostModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await createGroupPostRepository.updateGroupPost(
            updatedGroupPostModel: uploadGroupPostModel);
      } else {
        await createGroupPostRepository.uploadGroupPost(
            uploadGroupPostModel: uploadGroupPostModel);
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
