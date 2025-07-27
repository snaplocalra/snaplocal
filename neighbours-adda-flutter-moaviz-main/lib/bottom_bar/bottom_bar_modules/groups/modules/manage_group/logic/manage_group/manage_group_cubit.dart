// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/models/create_group_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/repository/manage_group_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_group_state.dart';

class ManageGroupCubit extends Cubit<ManageGroupState> {
  final ManageGroupRepository manageGroupRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageGroupCubit({
    required this.manageGroupRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageGroupState());

  ///This method can create and update the group
  Future<void> createOrUpdateGroupDetails({
    required CreateGroupModel groupDetailsModel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    String? groupId,
    String? existingCoverImageUrl,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      String? groupCoverImage;

      if (existingCoverImageUrl != null) {
        groupCoverImage = existingCoverImageUrl.split('/').last;
      }
      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.group,
          mediaList: pickedMediaList,
        );
        groupCoverImage = mediaUploadResponse.mediaList.first.mediaUrl;
      }

      //Edit group details
      if (groupId != null) {
        await manageGroupRepository.updateGroup(
          groupId: groupId,
          updatedGroupDetailsModel: groupDetailsModel,
          groupCoverImageUrl: groupCoverImage,
        );
      } else {
        //New group details
        await manageGroupRepository.createGroup(
          createGroupModel: groupDetailsModel,
          groupCoverImageUrl: groupCoverImage,
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
