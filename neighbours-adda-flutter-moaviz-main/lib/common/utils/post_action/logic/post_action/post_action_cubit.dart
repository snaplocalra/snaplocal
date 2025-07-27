import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/post_action/models/post_action_type_enum.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';

part 'post_action_state.dart';

class PostActionCubit extends Cubit<PostActionState> {
  final PostActionRepository postActionRepository;
  PostActionCubit(this.postActionRepository) : super(const PostActionState());

  //Market place
  Future<void> saveUnsavePost({
    required String postId,
    required PostActionType postActionType,
  }) async {
    try {
      emit(state.copyWith(isSaveRequestLoading: true));
      await postActionRepository.saveUnSavePost(
        postId: postId,
        postActionType: postActionType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isSaveRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> deleteMarketPlacePost({
    required String postId,
    required MarketPlaceType marketPlaceType,
  }) async {
    try {
      emit(state.copyWith(isDeleteRequestLoading: true));
      await postActionRepository.deleteMarketPlacePost(
        postId: postId,
        marketPlaceType: marketPlaceType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isDeleteRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  //Social post
  Future<void> saveUnsaveSocialPost({
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
  }) async {
    try {
      emit(state.copyWith(isSaveRequestLoading: true));
      await postActionRepository.saveUnSaveSocialPost(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isSaveRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  //view Social post
  Future<void> viewSocialPost({
    required String postId,
    required PostType postType,
  }) async {
    try {
      emit(state.copyWith(isSaveRequestLoading: true));
      await postActionRepository.viewSocialPost(
        postId: postId,
        postType: postType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isSaveRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }


  Future<void> deleteSocialPost({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      emit(state.copyWith(isDeleteRequestLoading: true));
      await postActionRepository.deleteSocialPost(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
      );

      //2 seconds delay
      await Future.delayed(const Duration(seconds: 2));

      if (isClosed) {
        return;
      }
      emit(state.copyWith(isDeleteRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> changeSharePermission({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
    required PostSharePermission postSharePermission,
  }) async {
    try {
      emit(state.copyWith(isSharePermissionLoading: true));
      await postActionRepository.changePostSharePermission(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        postShareControlEnum: postSharePermission,
      );
      emit(state.copyWith());
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isChangeShareRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  void changeCommentPermission({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
    required PostCommentPermission postCommentPermission,
  }) async {
    try {
      emit(state.copyWith(isCommentPermissionLoading: true));
      await postActionRepository.changePostCommentPermission(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        postCommentControlEnum: postCommentPermission,
      );
      emit(state.copyWith());
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(isChangeCommentRequestFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  //Close poll
  void closePoll({
    required String postId,
    required PostFrom postFrom,
  }) async {
    try {
      emit(state.copyWith(isClosePollRequestLoading: true));
      await postActionRepository.closePoll(
        postId: postId,
        postFrom: postFrom,
      );
      emit(state.copyWith(isClosePollRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }

  //news toggle follow
  void newsChannelToggleFollow(String channelId) async {
    try {
      emit(state.copyWith(isFollowRequestLoading: true));
      await postActionRepository.newsChannelToggleFollow(channelId);
      emit(state.copyWith(isFollowRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }
}
