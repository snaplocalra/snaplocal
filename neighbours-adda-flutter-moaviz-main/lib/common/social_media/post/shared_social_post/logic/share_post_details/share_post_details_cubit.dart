// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_rsa/fast_rsa.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/repository/share_post_details_repository.dart';
import 'package:snap_local/common/utils/share/repository/value_compressor_repository.dart';

part 'share_post_details_state.dart';

class SharePostDetailsCubit extends Cubit<PostDetailsState> {
  final SharePostDetailsRepository sharePostDetailsRepository;
  SharePostDetailsCubit(this.sharePostDetailsRepository)
      : super(const PostDetailsState());

  //Fetch the shared post details from the deeplink
  Future<void> fetchDeeplinkSharedPostDetails(String encryptedData) async {
    try {
      emit(state.copyWith(dataLoading: true));

      //Decrypting the data
      final decryptedData =
          await ValueCompressorRepository().decompressValue(encryptedData);
      if (decryptedData == null) {
        throw ("Unable to open the post");
      }

      //Converting the decrypted data to model
      final sharePostLinkData = SharedPostDataModel.fromJson(decryptedData);

      //Fetching the social post details
      final socialPostDetails =
          await sharePostDetailsRepository.fetchSocialPostDetails(
        postId: sharePostLinkData.postId,
        postType: sharePostLinkData.postType,
        postFrom: sharePostLinkData.postFrom,
        shareType: sharePostLinkData.shareType,
      );

      //Emitting the state with the social post details
      emit(state.copyWith(socialPostDetails: socialPostDetails));
      return;
    } catch (e) {
      if (isClosed) {
        return;
      }

      if (e is RSAException) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        emit(state.copyWith(error: "Unable to open the post"));
      } else if (state.socialPostDetails == null) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        emit(state.copyWith(error: e.toString()));
      } else {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        ThemeToast.errorToast(e.toString());
      }
      return;
    }
  }

  //Fetch the shared post details from the notification tap
  Future<void> fetchNotificationTapSharedPostDetails(
    SharedPostDataModel sharedPostDataModel,
  ) async {
    try {
      emit(state.copyWith(dataLoading: true));

      //Fetching the social post details
      final socialPostDetails =
          await sharePostDetailsRepository.fetchSocialPostDetails(
        postId: sharedPostDataModel.postId,
        postType: sharedPostDataModel.postType,
        postFrom: sharedPostDataModel.postFrom,
        shareType: sharedPostDataModel.shareType,
      );

      //Emitting the state with the social post details
      emit(state.copyWith(socialPostDetails: socialPostDetails));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }

      if (state.socialPostDetails == null) {
        emit(state.copyWith(error: e.toString()));
      } else {
        ThemeToast.errorToast(e.toString());
      }
      return;
    }
  }
}
