import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/model/share_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/repository/share_the_post_repository.dart';

part 'share_the_post_state.dart';

class ShareThePostCubit extends Cubit<ShareThePostState> {
  final ShareThePostRepository shareThePostRepository;
  ShareThePostCubit(this.shareThePostRepository)
      : super(const ShareThePostState());

  //Share the post
  Future<void> shareThePost(
      InAppSharePostDataModel inAppSharePostDataModel) async {
    try {
      emit(state.copyWith(isRequestProcessing: true));
      //Call the repository to share the post
      await shareThePostRepository.shareThePost(inAppSharePostDataModel);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  //Update shared post
  Future<void> updateSharedPost(
      InAppSharePostDataModel inAppSharePostDataModel) async {
    try {
      emit(state.copyWith(isRequestProcessing: true));
      //Call the repository to share the post
      await shareThePostRepository.updateSharedPost(inAppSharePostDataModel);
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
