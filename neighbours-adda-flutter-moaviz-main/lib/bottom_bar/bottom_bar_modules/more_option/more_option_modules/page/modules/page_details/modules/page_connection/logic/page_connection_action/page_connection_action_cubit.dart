import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/repository/page_connection_repository.dart';

part 'page_connection_action_state.dart';

class PageConnectionActionCubit extends Cubit<PageConnectionActionState> {
  final PageConnectionRepository pageConnectionRepository;

  PageConnectionActionCubit({required this.pageConnectionRepository})
      : super(const PageConnectionActionState());

  Future<void> stopLoading() async {
    try {
      emit(state.copyWith(stopAllLoading: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  Future<void> sendAndCancelPageFollowRequest(String pageId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isSendAndRemovePageFollowRequestLoading: true));
      await pageConnectionRepository.sendAndRemovePageFollowRequest(
          pageId: pageId);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  Future<void> exitPageFollowRequest(String pageId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isExitPageRequestLoading: true));
      await pageConnectionRepository.sendAndRemovePageFollowRequest(
          pageId: pageId);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }
}
