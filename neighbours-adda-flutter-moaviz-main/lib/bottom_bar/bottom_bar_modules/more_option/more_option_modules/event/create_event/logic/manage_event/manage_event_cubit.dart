import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/model/manage_event_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/repository/manage_event_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_event_state.dart';

class ManageEventCubit extends Cubit<ManageEventState> {
  final ManageEventRepository manageEventRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageEventCubit({
    required this.manageEventRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageEventState());

  // Future<void> manageEvent({
  //   required ManageEventModel manageEventModel,
  //   bool isEdit = false,
  // }) async {
  //   try {
  //           emit(state.copyWith(isLoading: true));

  //     await manageEventRepository.manageEvent(
  //       manageEventModel: manageEventModel,
  //       isEdit: isEdit,
  //     );
  //           emit(state.copyWith(isRequestSuccess: true));

  //   } catch (e) {
  // Record the error in Firebase Crashlytics
  // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     if (isClosed) {
  //       return;
  //     }
  //     ThemeToast.errorToast(e.toString());
  //           emit(state.copyWith(isRequestFailed: true));

  //   }
  // }

  Future<void> manageEventPost({
    required ManageEventModel manageEventModel,
    required List<MediaFileModel> pickedMediaList,
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.event,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        manageEventModel.media.addAll(mediaUploadResponse.mediaList);
      }

      if (isEdit) {
        await manageEventRepository.updateEventPost(manageEventModel);
      } else {
        await manageEventRepository.uploadEventPost(manageEventModel);
      }

      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> deleteEvent(String pollId) async {
    try {
      emit(state.copyWith(isLoading: true));

      await manageEventRepository.deleteEvent(pollId);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(isRequestFailed: true));
    }
  }

  // Future<void> giveVoteOnEvent({
  //   required String pollId,
  //   required String optionId,
  // }) async {
  //   try {
  //           emit(state.copyWith(isLoading: true));

  //     await manageEventRepository.giveVoteOnEvent(
  //       pollId: pollId,
  //       optionId: optionId,
  //     );
  //           emit(state.copyWith(isRequestSuccess: true));

  //   } catch (e) {
  // Record the error in Firebase Crashlytics
  // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     if (isClosed) {
  //       return;
  //     }
  //     ThemeToast.errorToast(e.toString());
  //           emit(state.copyWith(isRequestFailed: true));

  //   }
  // }
}
