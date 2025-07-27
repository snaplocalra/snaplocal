import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';

part 'profile_connection_action_state.dart';

class ProfileConnectionActionCubit extends Cubit<ProfileConnectionActionState> {
  final ProfileConnectionRepository connectionRepository;
  ProfileConnectionActionCubit({required this.connectionRepository})
      : super(const ProfileConnectionActionState());

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

  Future<void> acceptConnection({
    required String connectionId,
    required String neighboursId,
  }) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isAcceptConnectionLoading: true));
      await connectionRepository.acceptConnection(connectionId: connectionId);

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

  Future<void> rejectConnection({
    required String connectionId,
    required String neighboursId,
  }) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isRejectConnectionLoading: true));
      await connectionRepository.rejectConnection(connectionId: connectionId);
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

  Future<void> sendConnectionRequest(String targetingUserId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isSendConnectionRequestLoading: true));
      await connectionRepository.sendConnectionRequest(
          targetingUserId: targetingUserId);
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

  // Follow and Unfollow Official Account
  Future<void> followUnfollowOfficialAccount(String userId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isFollowingLoading: true));
      await connectionRepository.followUnfollowOfficialAccount(
          userId: userId);
      emit(state.copyWith(isFollowingSuccess: true));
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


  Future<void> followUnfollowInfluencerAccount(String userId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isFollowingLoading: true));
      await connectionRepository.followUnfollowInfluencerAccount(
          userId: userId);
      emit(state.copyWith(isFollowingSuccess: true));
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

  //toggle block user
  Future<void> toggleBlockUser(String userId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(toggleBlockLoading: true));

      await Future.wait([
        //Toggle the block in firebase
        FirebaseChatSettingRepository().toggleUserBlock(userId),
        //Toggle the block in server
        connectionRepository.toggleBlockUser(userId)
      ]);

      emit(state.copyWith(toggleBlockRequestSuccess: true));
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
