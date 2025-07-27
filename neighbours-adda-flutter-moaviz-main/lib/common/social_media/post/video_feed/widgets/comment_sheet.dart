import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/comment_builder.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/send_comment_widget.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_actions/comment_actions_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reaction_box_hide_controller/comment_reaction_box_hide_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reply_status_controller/comment_reply_status_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/send_comment/send_comment_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';

class CommentBottomSheet extends StatefulWidget {
  final SocialPostModel post;

  const CommentBottomSheet({
    super.key,
    required this.post,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final commentFocusNode = FocusNode();
  final commentController = TextEditingController();
  final postViewScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CommentReplyStatusControllerCubit(ownerName: context.read<ManageProfileDetailsBloc>().state.profileDetailsModel?.name ?? '')),
        BlocProvider(create: (_) => CommentControllerCubit(commentRepository: context.read<CommentRepository>())),
        BlocProvider(create: (context) => CommentActionsCubit(
          commentRepository: context.read<CommentRepository>(),
          commentControllerCubit: context.read<CommentControllerCubit>(),
        )),
        BlocProvider(create: (_) => SendCommentCubit()),
        BlocProvider(create: (_) => CommentReactionBoxHideControllerCubit()),
        BlocProvider(create: (_) => ShowReactionCubit()),
      ],
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CommentBuilder(
                    scrollController: postViewScrollController,
                    postId: widget.post.id,
                    postFrom: widget.post.postFrom,
                    postType: widget.post.postType,
                    commentController: commentController,
                    commentFocusNode: commentFocusNode,
                  ),
                ),
              ),
              BlocBuilder<CommentReplyStatusControllerCubit, CommentReplyStatusControllerState>(
                builder: (context, replyState) {
                  final String hint = replyState.isReply
                      ? "${tr(LocaleKeys.replyTo)} ${replyState.userName}"
                      : "${tr(LocaleKeys.commentAs)} ${replyState.userName}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (replyState.isReply)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: GestureDetector(
                            onTap: () => context.read<CommentReplyStatusControllerCubit>().toggleReply(isReply: false),
                            child: Text(tr(LocaleKeys.cancelReply), style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                        ),
                      BlocBuilder<CommentActionsCubit, CommentActionsState>(
                        builder: (context, commentActionsState) {
                          return SendCommentWidget(
                            hint: hint,
                            enable: !commentActionsState.requestLoading,
                            textController: commentController,
                            focusNode: commentFocusNode,
                            onCommentSend: (message) {
                              context.read<SendCommentCubit>().onComment(message);
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
