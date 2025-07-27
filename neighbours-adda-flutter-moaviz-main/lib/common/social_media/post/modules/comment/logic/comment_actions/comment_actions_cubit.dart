import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/temp_comment_index_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';

part 'comment_actions_state.dart';

class CommentActionsCubit extends Cubit<CommentActionsState> {
  final CommentControllerCubit commentControllerCubit;
  final CommentRepository commentRepository;

  CommentActionsCubit({
    required this.commentRepository,
    required this.commentControllerCubit,
  }) : super(const CommentActionsState());

  Future<void> postComment({
    required String postId,
    String? parentCommentId,
    required String comment,
    required PostFrom postFrom,
    required PostType postType,
    required TempCommentIndexModel tempCommentIndexModel,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await commentRepository
          .postComment(
        postId: postId,
        comment: comment,
        parentCommentId: parentCommentId,
        postFrom: postFrom,
        postType: postType,
      )
          .then((commentId) async {
        await commentControllerCubit.updateTempComment(
          tempCommentIndexModel: tempCommentIndexModel,
          commentId: commentId,
        );
      });

      if (isClosed) {
        return;
      }
      emit(state.copyWith(
        requestSuccess: true,
        increaseCommentCount: true,
      ));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
    }
  }

  Future<void> deleteComment({
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostType postType,
    required PostFrom postFrom,
    required TempCommentIndexModel tempCommentIndexModel,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      //Remove local comment
      await commentControllerCubit.removeComment(
          tempCommentIndexModel: tempCommentIndexModel);

      //Remove comment from server
      await commentRepository.deleteComment(
        postId: postId,
        parentCommentId: parentCommentId,
        childCommentId: childCommentId,
        postFrom: postFrom,
        postType: postType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(
        decreaseCommentCount: true,
        deleteSuccess: true,
      ));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
    }
  }

  //Hide comment
  Future<void> hideComment({
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostType postType,
    required PostFrom postFrom,
    required TempCommentIndexModel tempCommentIndexModel,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      //Remove local comment
      await commentControllerCubit.removeComment(
          tempCommentIndexModel: tempCommentIndexModel);

      //Remove comment from server
      await commentRepository.hideComment(
        postId: postId,
        parentCommentId: parentCommentId,
        childCommentId: childCommentId,
        postFrom: postFrom,
        postType: postType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(decreaseCommentCount: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
    }
  }

  //Remove comment from list
  Future<void> removeCommentFromList({
    required TempCommentIndexModel tempCommentIndexModel,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      //Remove local comment
      await commentControllerCubit.removeComment(
          tempCommentIndexModel: tempCommentIndexModel);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(decreaseCommentCount: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
    }
  }

  //edit comment
  Future<void> editComment({
    required String postId,
    required String parentCommentId,
    required String? childCommentId,
    required String comment,
    required PostType postType,
    required PostFrom postFrom,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await commentRepository.editComment(
        postId: postId,
        comment: comment,
        parentCommentId: parentCommentId,
        childCommentId: childCommentId,
        postFrom: postFrom,
        postType: postType,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(requestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
    }
  }
}
