// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/manage_news_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/repository/manage_news_post_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_news_post_state.dart';

class ManageNewsPostCubit extends Cubit<ManageNewsPostState> {
  final ManageNewsPostRepository manageNewsRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageNewsPostCubit({
    required this.manageNewsRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageNewsPostState());

  ///This method can create and update the group
  Future<void> createOrUpdateNewsPostDetails({
    required ManageNewsPostModel newspostDetailsModel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    String? newspostId,
    String? existingCoverImageUrl,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.news,
          mediaList: pickedMediaList,
        );
        newspostDetailsModel.media.addAll(mediaUploadResponse.mediaList);
      }

      //Edit newspost details
      if (newspostId != null) {
        await manageNewsRepository.updateNews(
          updatedNewsDetailsModel: newspostDetailsModel,
        );
      } else {
        //New group details
        await manageNewsRepository.createNews(
            createNewsModel: newspostDetailsModel);
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

  //delete newspost
  Future<void> deleteNewsPost(String newspostId) async {
    try {
      emit(state.copyWith(deleteLoading: true));
      await manageNewsRepository.deleteNews(newsId: newspostId);
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
}
