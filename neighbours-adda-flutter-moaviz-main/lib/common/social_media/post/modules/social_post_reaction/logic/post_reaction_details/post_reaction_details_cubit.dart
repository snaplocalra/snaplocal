import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';

part 'post_reaction_details_state.dart';

class PostReactionDetailsCubit extends Cubit<PostReactionDetailsState> {
  final ReactionRepository reactionRepository;
  PostReactionDetailsCubit(this.reactionRepository)
      : super(const PostReactionDetailsState());

  void fetchPostReactionDetails({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final postReactionDetails =
          await reactionRepository.getPostReactionDetails(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
      );
      emit(state.copyWith(postReactionDetails: postReactionDetails));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
