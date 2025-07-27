import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/comment_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/temp_comment_index_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';

part 'comment_controller_state.dart';

class CommentControllerCubit extends Cubit<CommentControllerState> {
  final CommentRepository commentRepository;

  CommentControllerCubit({required this.commentRepository})
      : super(
          CommentControllerState(
            commentListModel: CommentListModel.emptyModel(),
          ),
        );

  void updateReaction(
    ReactionEmojiModel? reactionEmojiModel, {
    required bool isFirstReaction,
    required int parentCommentIndex,
    required int? childCommentIndex,
  }) {
    if (childCommentIndex != null) {
      //update in the child comment
      state.commentListModel.data[parentCommentIndex].reply![childCommentIndex]
          .reactionEmojiModel = reactionEmojiModel;
    } else {
      //update in the parent comment
      state.commentListModel.data[parentCommentIndex].reactionEmojiModel =
          reactionEmojiModel;
    }
    emit(state.copyWith(commentLoading: true));
    emit(state.copyWith(commentLoading: false));
  }

  Future<void> fetchComments({
    bool loadMoreData = false,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      //Late initial for the comment model
      late CommentListModel commentList;
      if (loadMoreData) {
        //Run the fetch home feed API, if it is not the last page.
        if (!state.commentListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          state.commentListModel.paginationModel.currentPage += 1;

          commentList = await commentRepository.fetchComments(
            page: state.commentListModel.paginationModel.currentPage,
            postFrom: postFrom,
            postType: postType,
            postId: postId,
          );

          //emit the updated state.
          emit(state.copyWith(
            commentListModel: state.commentListModel.paginationCopyWith(
              newData: commentList,
            ),
            commentLoading: false,
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        emit(state.copyWith(commentLoading: true));
        commentList = await commentRepository.fetchComments(
          postFrom: postFrom,
          postType: postType,
          postId: postId,
          page: 1,
        );
        //Emit the new state if it is the initial load request
        emit(
          state.copyWith(
            commentListModel: commentList,
            commentLoading: false,
          ),
        );
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }

      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(commentLoading: false));
      return;
    }
  }

  TempCommentIndexModel addTempCommentToList({
    required CommentModel commentModel,

    ///If null then the comment is a parent comment.
    ///If not null then the comment will coming under some parent comment as reply
    int? parentIndex,
  }) {
    final commentList = state.commentListModel.data;

    ///this variable will carry the index of the child, if the comment type is a nested comment
    int? childCommentIndex;

    //Nested comment
    if (parentIndex != null) {
      if (commentList[parentIndex].reply == null) {
        //Set the 1st reply
        childCommentIndex = 0;
        //Add the 1st reply
        commentList[parentIndex] =
            commentList[parentIndex].copyWith(reply: [commentModel]);
      } else {
        //Insert data at the last index
        childCommentIndex = commentList[parentIndex].reply!.length; //last index
        commentList[parentIndex].reply!.insert(childCommentIndex, commentModel);
      }

      //In temp list new child always set at 0 index
    } else {
      //Parent comment
      commentList.insert(0, commentModel);
    }

    emit(state.copyWith(
      commentListModel: state.commentListModel.copyWith(data: commentList),
      commentLoading: false,
    ));

    return TempCommentIndexModel(
      parentCommentIndex: parentIndex ?? 0,
      childCommentIndex: childCommentIndex,
    );
  }

  //update the comment in the list
  void updateCommentInList({
    required CommentModel commentModel,
    required TempCommentIndexModel tempCommentIndexModel,
  }) {
    final commentList = state.commentListModel.data;

    //Nested comment
    if (tempCommentIndexModel.childCommentIndex != null) {
      //Assign the updated data
      commentList[tempCommentIndexModel.parentCommentIndex]
          .reply![tempCommentIndexModel.childCommentIndex!] = commentModel;
    } else {
      //Assign the updated data
      commentList[tempCommentIndexModel.parentCommentIndex] = commentModel;
    }

    emit(state.copyWith(
      commentListModel: state.commentListModel.copyWith(data: commentList),
      commentLoading: false,
    ));
  }

  ///Update the id of the recent added comment with the server
  Future<void> updateTempComment({
    required TempCommentIndexModel tempCommentIndexModel,

    ///This comment id will come after the post uploaded in the server
    required String commentId,
  }) async {
    final commentList = state.commentListModel.data;

    //Nested comment
    if (tempCommentIndexModel.childCommentIndex != null) {
      //Assign the updated data
      commentList[tempCommentIndexModel.parentCommentIndex]
              .reply![tempCommentIndexModel.childCommentIndex!] =
          //update child comment id
          commentList[tempCommentIndexModel.parentCommentIndex]
              .reply![tempCommentIndexModel.childCommentIndex!]
              .copyWith(id: commentId);
    } else {
      //Assign the updated data
      commentList[tempCommentIndexModel.parentCommentIndex] =
          //update Parent comment id
          commentList[tempCommentIndexModel.parentCommentIndex]
              .copyWith(id: commentId);
    }

    emit(state.copyWith(
      commentListModel: state.commentListModel.copyWith(data: commentList),
      commentLoading: false,
    ));
    return;
  }

  Future<void> removeComment({
    required TempCommentIndexModel tempCommentIndexModel,
  }) async {
    final commentList = state.commentListModel.data;

    //Nested comment
    if (tempCommentIndexModel.childCommentIndex != null) {
      //update child comment id
      commentList[tempCommentIndexModel.parentCommentIndex]
          .reply!
          .removeAt(tempCommentIndexModel.childCommentIndex!);
    } else {
      //update Parent comment id
      commentList.removeAt(tempCommentIndexModel.parentCommentIndex);
    }

    emit(state.copyWith(
      commentListModel: state.commentListModel.copyWith(data: commentList),
      commentLoading: false,
    ));
    return;
  }
}
