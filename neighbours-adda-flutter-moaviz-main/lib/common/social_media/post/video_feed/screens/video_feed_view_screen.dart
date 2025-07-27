import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_actions/comment_actions_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reaction_box_hide_controller/comment_reaction_box_hide_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reply_status_controller/comment_reply_status_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/send_comment/send_comment_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/comment_builder.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/send_comment_widget.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';

class PostDetailsViewScreen extends StatefulWidget {
  final bool modifyWithPostType;
  final bool allowNavigation;

  const PostDetailsViewScreen({
    super.key,
    this.modifyWithPostType = false,
    this.allowNavigation = true,
  });

  static const routeName = 'post_details_view';

  @override
  State<PostDetailsViewScreen> createState() => _PostMediaViewScreenState();
}

class _PostMediaViewScreenState extends State<PostDetailsViewScreen> {
  final postViewScrollController = ScrollController();

  final commentReactionBoxHideControllerCubit =
      CommentReactionBoxHideControllerCubit();

  //Post model
  late SocialPostModel socialPostDetailsModel =
      context.read<PostDetailsControllerCubit>().state.socialPostModel;

  //Comment controller
  final commentFocusNode = FocusNode();
  final commentController = TextEditingController();

  void requestFocusOnComment() {
    //Close the keyboard if in focus
    commentFocusNode.unfocus();

    //Here Future.delayed is used to open the keyboard after 100ms delay
    //after the commentFocusNode.unfocus() is called,
    //so that the keyboard is closed first and then opened again
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        //open keyboard for comment
        commentFocusNode.requestFocus();
      },
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollToEnd(postViewScrollController);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      postViewScrollController.position.addListener(() {
        //If the user start to scroll the screen, close the reaction box
        context.read<ShowReactionCubit>().closeReactionEmojiOption();
        commentReactionBoxHideControllerCubit.closeRectionBox();
      });

      if (context.read<CommentViewControllerCubit>().state.enableComment) {
        //Commited to remove the auto focus on comment as per client requirement
        //
        //open keyboard automatically
        // commentFocusNode.requestFocus();
        //
        //Here Future.delayed is used to scroll to end of the list after 500ms,
        //so that the list is fully loaded and then we can scroll to end
        scrollToBottom();
      }

      //listen to the comment controller
      context.read<CommentViewControllerCubit>().stream.listen((event) {
        if (event.enableComment) {
          scrollToBottom();
        }
      });
    });
  }

  @override
  void dispose() {
    commentFocusNode.dispose();
    commentController.dispose();
    postViewScrollController.dispose();
    super.dispose();
  }

  void popScreen({bool value = false}) async {
    context.read<CommentViewControllerCubit>().disableCommentView();
    context.read<ShowReactionCubit>().closeReactionEmojiOption();
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop(value);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: commentReactionBoxHideControllerCubit),
        BlocProvider(
          create: (context) => CommentReplyStatusControllerCubit(
            ownerName: context
                .read<ManageProfileDetailsBloc>()
                .state
                .profileDetailsModel!
                .name,
          ),
        ),
        BlocProvider(
          create: (context) => CommentControllerCubit(
            commentRepository: context.read<CommentRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => CommentActionsCubit(
            commentRepository: context.read<CommentRepository>(),
            commentControllerCubit: context.read<CommentControllerCubit>(),
          ),
        ),
        BlocProvider(create: (context) => SendCommentCubit()),
      ],
      child: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              return;
            }
            popScreen();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              onPop: () async {
                popScreen();
                return false;
              },
            ),
            body: BlocConsumer<CommentViewControllerCubit,
                CommentViewControllerState>(
              listener: (context, commentViewControllerState) {
                if (commentViewControllerState.enableComment) {
                  requestFocusOnComment();
                }
              },
              builder: (context, commentViewControllerState) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: postViewScrollController,
                        children: [
                          PostViewWidget(
                            key: ValueKey(socialPostDetailsModel.id),
                            enableComment: false,
                            verticalPostView: true,
                            allowPostDetailsOpen: false,
                            allowNavigation: widget.allowNavigation,
                          ),
                          if (commentViewControllerState.enableComment)
                            CommentBuilder(
                              scrollController: postViewScrollController,
                              postId: socialPostDetailsModel.id,
                              postFrom: socialPostDetailsModel.postFrom,
                              postType: socialPostDetailsModel.postType,
                              commentController: commentController,
                              commentFocusNode: commentFocusNode,
                            ),
                        ],
                      ),
                    ),
                    if (commentViewControllerState.enableComment)
                      BlocBuilder<CommentReplyStatusControllerCubit,
                          CommentReplyStatusControllerState>(
                        builder: (context, commentReplyStatusControllerState) {
                          final replyUserName =
                              commentReplyStatusControllerState.userName;
                          final String hint = commentReplyStatusControllerState
                                  .isReply
                              ? "${tr(LocaleKeys.replyTo)} $replyUserName"
                              : "${tr(LocaleKeys.commentAs)} $replyUserName";
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible:
                                    commentReplyStatusControllerState.isReply,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // disbale reply mode
                                      context
                                          .read<
                                              CommentReplyStatusControllerCubit>()
                                          .toggleReply(isReply: false);
                                    },
                                    child: Text(
                                      tr(LocaleKeys.cancelReply),
                                      style: TextStyle(
                                        color: ApplicationColours
                                            .themeLightPinkColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              BlocBuilder<CommentActionsCubit,
                                  CommentActionsState>(
                                builder: (context, commentActionsState) {
                                  return SendCommentWidget(
                                    hint: hint,
                                    enable: !commentActionsState.requestLoading,
                                    textController: commentController,
                                    focusNode: commentFocusNode,
                                    onCommentSend: (message) async {
                                      // //Scroll to start
                                      // scrollToStart(postViewScrollController);
                                      context
                                          .read<SendCommentCubit>()
                                          .onComment(message);
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
