// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/models/create_page_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/repository/manage_page_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_page_state.dart';

class ManagePageCubit extends Cubit<ManagePageState> {
  final ManagePageRepository managePageRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManagePageCubit({
    required this.managePageRepository,
    required this.mediaUploadRepository,
  }) : super(const ManagePageState());

  ///This method can create and update the group
  Future<void> createOrUpdatePageDetails({
    required CreatePageModel pageDetailsModel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    String? pageId,
    String? existingCoverImageUrl,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      String? pageCoverImage;

      if (existingCoverImageUrl != null) {
        pageCoverImage = existingCoverImageUrl.split('/').last;
      }
      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.page,
          mediaList: pickedMediaList,
        );
        pageCoverImage = mediaUploadResponse.mediaList.first.mediaUrl;
      }

      //Edit page details
      if (pageId != null) {
        await managePageRepository.updatePage(
          pageId: pageId,
          updatedPageDetailsModel: pageDetailsModel,
          pageCoverImageUrl: pageCoverImage,
        );
      } else {
        //New group details
        await managePageRepository.createPage(
          createPageModel: pageDetailsModel,
          pageCoverImageUrl: pageCoverImage,
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

  //delete page
  Future<void> deletePage(String pageId) async {
    try {
      emit(state.copyWith(deleteLoading: true));
      await managePageRepository.deletePage(pageId: pageId);
      emit(state.copyWith(deleteSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }

  //block page
  Future<void> toggleBlockPage(String pageId) async {
    try {
      emit(state.copyWith(toggleBlockLoading: true));
      await managePageRepository.toggleBlockPage(pageId: pageId);
      emit(state.copyWith(toggleBlockSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }
}
