import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_actions/comment_actions_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reply_status_controller/comment_reply_status_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/send_comment/send_comment_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/comment_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/comment_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/comment_update_strategy.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_comment_count_state.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';
import 'package:uuid/uuid.dart';

class CommentBuilder extends StatefulWidget {
  final PostFrom postFrom;
  final PostType postType;
  final String postId;
  final ScrollController scrollController;
  final FocusNode commentFocusNode;
  final TextEditingController commentController;
  const CommentBuilder({
    super.key,
    required this.postId,
    required this.postFrom,
    required this.postType,
    required this.scrollController,
    required this.commentFocusNode,
    required this.commentController,
  });

  @override
  State<CommentBuilder> createState() => _CommentBuilderState();
}

class _CommentBuilderState extends State<CommentBuilder> {
  late ProfileDetailsModel ownerProfileDetails =
      context.read<ManageProfileDetailsBloc>().state.profileDetailsModel!;

  ///If the user adding comment as a reply then both commentId and parentIndex required
  String? commentId;
  int? parentIndex;

  void removeCommentTag() {
    commentId = null;
    parentIndex = null;
  }

  void addCommentTag({
    required String parentCommentId,
    required int parentCommentIndex,
  }) {
    commentId = parentCommentId;
    parentIndex = parentCommentIndex;
  }

  Future<void> onComment({required String comment}) async {
    //Create a temporary model to show immediately
    final commentModel = CommentModel(
      id: const Uuid().v1(),
      comment: comment,
      isOwnComment: true,
      allowDelete: true, // comment owner can delete their own comment
      allowEdit: true, // comment owner can edit their own comment
      editedComment: false,
      createdTime: DateTime.now(),
      commentedByUserDetails: CommentedByUserDetails(
        id: ownerProfileDetails.id,
        name: ownerProfileDetails.name,
        image: ownerProfileDetails.profileImage,
        address: ownerProfileDetails.location!.address,
      ),
    );

    //Reaction call back to update on the UI
    final tempCommentIndexModel =
        context.read<CommentControllerCubit>().addTempCommentToList(
              commentModel: commentModel,
              parentIndex: parentIndex,
            );

    if (mounted) {
      //update on server
      await context
          .read<CommentActionsCubit>()
          .postComment(
            postId: widget.postId,
            comment: comment,
            parentCommentId: commentId,
            postFrom: widget.postFrom,
            postType: widget.postType,
            tempCommentIndexModel: tempCommentIndexModel,
          )
          .whenComplete(() {
        if (mounted) {
          //Reset reply status if enable
          context
              .read<CommentReplyStatusControllerCubit>()
              .toggleReply(isReply: false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //Load comments
    context.read<CommentControllerCubit>().fetchComments(
          postFrom: widget.postFrom,
          postType: widget.postType,
          postId: widget.postId,
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.position.isScrollingNotifier.addListener(() {
        //Scroll more comment data
        if (widget.scrollController.position.maxScrollExtent ==
            widget.scrollController.offset) {
          if (mounted) {
            context.read<CommentControllerCubit>().fetchComments(
                  loadMoreData: true,
                  postId: widget.postId,
                  postType: widget.postType,
                  postFrom: widget.postFrom,
                );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentActionsCubit, CommentActionsState>(
      listener: (context, commentActionsState) {
        // Logic to update the comment count
        if (commentActionsState.increaseCommentCount) {
          //update the comment count
          context.read<PostDetailsControllerCubit>().postStateUpdate(
              UpdateCommentCountState(IncrementCommentCount()));
        } else if (commentActionsState.decreaseCommentCount) {
          //update the comment count
          context.read<PostDetailsControllerCubit>().postStateUpdate(
                UpdateCommentCountState(
                  ReplaceCommentCount(
                    context
                        .read<CommentControllerCubit>()
                        .state
                        .totalCommentsCount,
                  ),
                ),
              );
        }
      },
      child: BlocListener<SendCommentCubit, SendCommentState>(
        listener: (context, sendCommentState) {
          if (sendCommentState is OnComment) {
            onComment(comment: sendCommentState.comment);
          }
        },
        child: BlocListener<CommentReplyStatusControllerCubit,
            CommentReplyStatusControllerState>(
          listener: (context, commentReplyStatusControllerState) {
            if (!commentReplyStatusControllerState.isReply) {
              removeCommentTag();
            }
          },
          child: BlocBuilder<CommentActionsCubit, CommentActionsState>(
            builder: (context, commentActionsState) {
              return BlocBuilder<CommentControllerCubit,
                  CommentControllerState>(
                builder: (context, commentControllerState) {
                  if (commentControllerState.commentLoading) {
                    return const ThemeSpinner(size: 30);
                  } else {
                    final commentListModel =
                        commentControllerState.commentListModel;
                    final logs = commentListModel.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            tr(LocaleKeys.comments),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        logs.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    tr(LocaleKeys.noCommentsYet),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                shrinkWrap: true,
                                itemCount: logs.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < logs.length) {
                                    final commentModel = logs[index];
                                    return BlocProvider(
                                      create: (context) =>
                                          ReportCubit(ReportRepository()),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Column(
                                          children: [
                                            CommentWidget(
                                              postId: widget.postId,
                                              parentCommentId: commentModel.id,
                                              parentCommentIndex: index,
                                              postFrom: widget.postFrom,
                                              postType: widget.postType,
                                              commentModel: commentModel,
                                              onReplyTap: commentActionsState
                                                      .requestLoading
                                                  ? null
                                                  : (userName) {
                                                      addCommentTag(
                                                        parentCommentId:
                                                            commentModel.id,
                                                        parentCommentIndex:
                                                            index,
                                                      );

                                                      widget.commentFocusNode
                                                          .requestFocus();

                                                      //For own comment, the @$userName will not come on reply tap
                                                      if (!commentModel
                                                          .isOwnComment) {
                                                        widget.commentController
                                                                .text =
                                                            "@$userName ";
                                                      }

                                                      //enable reply mode
                                                      context
                                                          .read<
                                                              CommentReplyStatusControllerCubit>()
                                                          .toggleReply(
                                                            isReply: true,
                                                            userName: userName,
                                                          );
                                                    },
                                            ),
                                            const ThemeDivider(
                                                height: 25, thickness: 2),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (commentListModel
                                        .paginationModel.isLastPage) {
                                      return const SizedBox.shrink();
                                    } else {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: ThemeSpinner(size: 30),
                                      );
                                    }
                                  }
                                },
                              ),
                      ],
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
