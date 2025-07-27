import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';

part 'hide_post_state.dart';

class HidePostCubit extends Cubit<HidePostState> {
  final HidePostRepository hidePostRepository;

  HidePostCubit(this.hidePostRepository) : super(const HidePostState());

  Future<void> hidetSocialPostReport({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
    required ReportType reportType,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await hidePostRepository.hideSocialPost(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        reportType: reportType,
      );
      emit(state.copyWith(requestSuccess: true));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
      return;
    }
  }
}
