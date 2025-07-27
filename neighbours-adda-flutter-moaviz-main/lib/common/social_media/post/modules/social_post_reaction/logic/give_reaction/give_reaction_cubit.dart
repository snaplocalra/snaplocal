import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';

part 'give_reaction_state.dart';

class GiveReactionCubit extends Cubit<GiveReactionState> {
  final ReactionRepository reactionRepository;
  GiveReactionCubit(
    this.reactionRepository,
  ) : super(const GiveReactionState());

  Future<void> givePostReaction({
    String? postTypeId,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
    required String reactionId,
  }) async {
    try {
      emit(state.copyWith(isRequestLoading: true));
      await reactionRepository.givePostReaction(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        reactionId: reactionId,
      );
      emit(state.copyWith());
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      return;
    }
  }

  Future<void> givePostCommentReaction({
    required String postId,
    required String parentCommentId,
    required String? childCommentId,
    required PostFrom postFrom,
    required PostType postType,
    required String reactionId,
  }) async {
    try {
      emit(state.copyWith(isRequestLoading: true));
      await reactionRepository.givePostCommentReaction(
        postId: postId,
        reactionId: reactionId,
        parentCommentId: parentCommentId,
        childCommentId: childCommentId,
        postFrom: postFrom,
        postType: postType,
      );
      emit(state.copyWith());
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());

      return;
    }
  }
}
