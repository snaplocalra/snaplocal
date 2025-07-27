import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_option_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/repository/manage_poll_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/media_response_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'poll_service_state.dart';

class PollServiceCubit extends Cubit<PollServiceState> {
  final ManagePollRepository managePollRepository;
  final MediaUploadRepository mediaUploadRepository;

  PollServiceCubit({
    required this.managePollRepository,
    required this.mediaUploadRepository,
  }) : super(const PollServiceState());

  Future<void> _uploadOptionImage(ManagePollOptionList optionList) async {
    try {
      final managePollOptionList = optionList.data;

      for (int i = 0; i < managePollOptionList.length; i++) {
        MediaUploadResponse? mediaUploadResponse;
        if (managePollOptionList[i].fileImage != null) {
          //Upload the picked media to server
          mediaUploadResponse = await mediaUploadRepository.uploadMedia(
            mediaUploadType: MediaUploadType.poll,
            mediaList: [managePollOptionList[i].fileImage!],
          );
        }

        if (mediaUploadResponse != null) {
          // Reassign the uploaded image path to the element in the array
          managePollOptionList[i] = managePollOptionList[i].copyWith(
            optionImage: mediaUploadResponse.mediaList.first.mediaUrl,
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> managePoll({
    required ManagePollModel managePollModel,
    bool isEdit = false,
  }) async {
    try {
      emit(state.copyWith(isRequestLoading: true));

      //if the user is in edit mode and the type is photo, then upload the media
      if (!isEdit && managePollModel.pollTypeEnum == PollTypeEnum.photo) {
        await _uploadOptionImage(managePollModel.managePollOptionList);
      }

      await managePollRepository.managePoll(
        isEdit: isEdit,
        managePollModel: managePollModel,
      );
      emit(state.copyWith(isManagePollRequestSuccess: true));
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

  // Future<void> deletePoll(String pollId) async {
  //   try {
  //     emit(state.copyWith(isRequestLoading: true));
  //     await managePollRepository.deletePoll(pollId);
  //     emit(state.copyWith(isDeleteRequestSuccess: true));
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     if (isClosed) {
  //       return;
  //     }
  //     ThemeToast.errorToast(e.toString());
  //     emit(state.copyWith(isRequestFailed: true));
  //   }
  // }

  Future<void> giveVoteOnPoll({
    required String pollId,
    required String optionId,
  }) async {
    try {
      emit(state.copyWith(isRequestLoading: true));
      managePollRepository.giveVoteOnPoll(
        pollId: pollId,
        optionId: optionId,
      );
      emit(state.copyWith(isVotingRequestSuccess: true));
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
}
