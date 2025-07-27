// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/repository/manage_news_channel_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_news_channel_state.dart';

class ManageNewsChannelCubit extends Cubit<ManageNewsChannelState> {
  final ManageNewsChannelRepository manageNewsChannelRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageNewsChannelCubit({
    required this.manageNewsChannelRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageNewsChannelState());

  ///This method can create and update the group
  Future<void> createOrUpdateNewsChannel({
    required ManageNewsChannelModel createNewsChannel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      String? coverImage;

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.news,
          mediaList: pickedMediaList,
        );
        coverImage = mediaUploadResponse.mediaList.first.mediaUrl;
      }

      //Edit news channel
      if (isEdit) {
        await manageNewsChannelRepository.updateNewsChannel(
          createNewsChannel.copyWith(coverImageUrl: coverImage),
        );
      } else {
        //Create news channel
        await manageNewsChannelRepository.createNewsChannel(
          createNewsChannel.copyWith(coverImageUrl: coverImage),
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
