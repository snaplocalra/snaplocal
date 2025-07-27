// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/screen/news_post_view_details_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/regular_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/safety_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/shared_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_reaction_state.dart';
import 'package:snap_local/common/social_media/post/post_details/screens/post_details_view_screen.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/event_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/lost_found_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/news_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/official_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/poll_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/regular_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/safety_post_view.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/category/shared_post_view.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';
import 'package:snap_local/common/utils/widgets/block_status.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../master_post/model/categories_view/official_post_model.dart';

class PostViewWidget extends StatefulWidget {
  final bool allowNavigation,
      verticalPostView,
      allowPostDetailsOpen,
      enableComment,
      enableGroupHeaderView,

      ///If true then the post view in the post share dialog
      isSharedView,

      ///If true then the special activity feature will be enabled on
      ///PollPostView and EventPostView
      enableSpecialActivity,

      ///If true then the post view will be open from chat
      openFromChat;

  final bool enableNewsPostAction;

  final void Function()? refreshParentData;

  const PostViewWidget({
    super.key,
    this.allowNavigation = false,
    this.enableComment = true,
    this.verticalPostView = false,
    this.allowPostDetailsOpen = false,
    this.enableGroupHeaderView = true,
    this.isSharedView = false,
    this.enableSpecialActivity = true,
    this.openFromChat = false,
    this.refreshParentData,
    this.enableNewsPostAction = true,
  });

  @override
  State<PostViewWidget> createState() => _PostViewWidgetState();
}

class _PostViewWidgetState extends State<PostViewWidget> {
  //Initialization of GiveReaction Cubit
  late GiveReactionCubit giveReactionCubit = GiveReactionCubit(context.read<ReactionRepository>());

  void navigateToPostDetails(SocialPostModel postDetails) {
    if (postDetails is NewsPostModel) {
      GoRouter.of(context).pushNamed(
        NewsPostViewDetailsScreen.routeName,
        queryParameters: {"id": postDetails.id},
        extra: {
          'postDetailsControllerCubit':
              context.read<PostDetailsControllerCubit>(),
          'showReactionCubit': context.read<ShowReactionCubit>(),
          'postActionCubit': context.read<PostActionCubit>(),
          'reportCubit': context.read<ReportCubit>(),
          'commentViewControllerCubit':
              context.read<CommentViewControllerCubit>(),
          'hidePostCubit': context.read<HidePostCubit>(),
        },
      ).then((value) {
        //This is a temporary solution to close the post details screen and
        //run the fetch data function in the parent screen
        if (value != null && value == true) {
          widget.refreshParentData?.call();
        }
      });
    } else {
      GoRouter.of(context).pushNamed(
        PostDetailsViewScreen.routeName,
        extra: <String, dynamic>{
          "reportCubit": context.read<ReportCubit>(),
          "postActionCubit": context.read<PostActionCubit>(),
          "postDetailsControllerCubit":
              context.read<PostDetailsControllerCubit>(),
          "showReactionCubit": context.read<ShowReactionCubit>(),
          "allowNavigation": widget.allowNavigation.toString(),
          "commentViewControllerCubit":
              context.read<CommentViewControllerCubit>(),
          "hidePostCubit": context.read<HidePostCubit>(),
        },
      ).then((value) {
        //This is a temporary solution to close the post details screen and
        //run the fetch data function in the parent screen
        if (value != null && value == true) {
          widget.refreshParentData?.call();
        }
      });
    }
  }

  void onReact({
    required ReactionEmojiModel reactionEmoji,
    bool removeReaction = false,
    required bool isFirstReaction,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    //Close the reaction option widget
    await context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() async {
      if (!removeReaction) {
        HapticFeedback.lightImpact();
        // context.read<ReactionAudioEffectControllerCubit>().playReactionSound();
      }

      //Reaction call back to update on the UI
      context
          .read<PostDetailsControllerCubit>()
          .postStateUpdate(UpdateReactionState(
            removeReaction ? null : reactionEmoji,
            isFirstReaction,
          ));

      //Api call
      await giveReactionCubit.givePostReaction(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        reactionId: reactionEmoji.id,
      );
    });
  }

  void onViewVideo({
    required SocialPostModel post,
    required String postId,
    required PostType postType,
  }) async {
     // context
      //     .read<PostDetailsControllerCubit>()
      //     .postStateUpdate(UpdatePostState(
      //   post
      // ));

      //Api call
      context
          .read<PostActionCubit>()
          .viewSocialPost(
        postId: postId,
        postType: postType,
      );
  }

  void openPostDetails(SocialPostModel postDetails) {
    ///////////////////////////
    //Close the reaction option widget if the user touch the post widget
    context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() {
      if (widget.openFromChat && mounted) {
        //Navigate to the shared post details screen to
        //load the post details with new state
        final sharePostLinkData = SharedPostDataModel(
          postId: postDetails.id,
          postType: postDetails.postType,
          postFrom: postDetails.postFrom,
          shareType: ShareType.general,
        );

        GoRouter.of(context).pushNamed(
          GeneralSharedSocialPostDetails.routeName,
          extra: sharePostLinkData,
        );
      } else {
        //Navigate to the post details screen
        navigateToPostDetails(postDetails);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: giveReactionCubit)],
      child: BlocBuilder<PostDetailsControllerCubit, PostDetailsControllerState>(
        builder: (context, postDetailsState) {
          final postDetails = postDetailsState.socialPostModel;

          final hidePost = postDetails.groupPageInfo != null &&
                  (postDetails.groupPageInfo!.blockedByAdmin ||
                      postDetails.groupPageInfo!.blockedByUser)
              ? true
              : false;

          return hidePost
              ? Center(
                  child: BlockStatus(
                    //page block status
                    blockedByAdmin: postDetails.groupPageInfo!.blockedByAdmin,
                    blockedByUser: postDetails.groupPageInfo!.blockedByUser,
                    isAdmin: postDetails.groupPageInfo!.postAdmin,
                    blockedByPageAdminMessage:
                        tr(LocaleKeys.thisPostIsNotAvailable),
                    blockedByUserMessage: tr(LocaleKeys.youcantviewthispost),
                  ),
                )
              : GestureDetector(
                  key: ValueKey(postDetails.id),
                  onTap: widget.allowPostDetailsOpen
                      ? () {
                          openPostDetails(postDetails);
                        }
                      : null,
                  child: RenderPostViewObject(
                    isSharedView: widget.isSharedView,
                    enableSpecialActivity: widget.enableSpecialActivity,
                    enableGroupHeaderView: widget.enableGroupHeaderView,
                    socialPostModel: postDetails,
                    verticalPostView: widget.verticalPostView,
                    enableNewsPostAction: widget.enableNewsPostAction,
                    onComment: () {
                      //Enable the comment view
                      context
                          .read<CommentViewControllerCubit>()
                          .enableCommentView();

                      final enableComment = context
                          .read<CommentViewControllerCubit>()
                          .state
                          .enableComment;

                      if (!widget.verticalPostView && enableComment) {
                        openPostDetails(postDetails);
                      }
                    },
                    onReact: (reactionEmoji, removeReaction) {
                      onReact(
                        reactionEmoji: reactionEmoji,
                        isFirstReaction: postDetails.reactionEmojiModel == null,
                        postId: postDetails.id,
                        postFrom: postDetails.postFrom,
                        postType: postDetails.postType,
                        removeReaction: removeReaction,
                      );
                    },
                    onVideoViewCount: (){
                      onViewVideo(
                        post: postDetails,
                        postId: postDetails.id,
                        postType: postDetails.postType,
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}

class RenderPostViewObject extends StatelessWidget {
  final bool verticalPostView,
      enableGroupHeaderView,
      isSharedView,
      enableSpecialActivity;
  final void Function() onComment;
  final void Function() onVideoViewCount;
  final void Function(ReactionEmojiModel, bool) onReact;
  final SocialPostModel socialPostModel;
  final bool enableNewsPostAction;
  const RenderPostViewObject({
    super.key,

    ///true when the post view in the post share dialog
    required this.isSharedView,
    required this.enableSpecialActivity,
    required this.socialPostModel,
    required this.verticalPostView,
    required this.enableGroupHeaderView,
    required this.onComment,
    required this.onVideoViewCount,
    required this.onReact,
    required this.enableNewsPostAction,
  });

  @override
  Widget build(BuildContext context) {
    switch (socialPostModel.runtimeType) {
      // case const (OfficialPostModel):
      //   return OfficialPostView(
      //     officialPostModel: socialPostModel as OfficialPostModel,
      //     verticalPostView: verticalPostView,
      //     onComment: onComment,
      //     onReact: onReact,
      //     enableGroupHeaderView: enableGroupHeaderView,
      //     isSharedView: isSharedView,
      //   );
      case const (RegularPostModel):
        return RegularPostView(
          regularPostModel: socialPostModel as RegularPostModel,
          verticalPostView: verticalPostView,
          onVideoViewCount: onVideoViewCount,
          onComment: onComment,
          onReact: onReact,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
        );
      case const (NewsPostModel):
        return NewsPostView(
          newsPostModel: socialPostModel as NewsPostModel,
          enableNewsPostAction: enableNewsPostAction,
          verticalPostView: verticalPostView,
          onComment: onComment,
          onReact: onReact,
          onVideoViewCount: onVideoViewCount,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
          hideViewMore: !enableSpecialActivity,
        );
      case const (EventPostModel):
        return EventPostView(
          eventPostModel: socialPostModel as EventPostModel,
          verticalPostView: verticalPostView,
          onReact: onReact,
          onComment: onComment,
          onVideoViewCount: onVideoViewCount,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
          hideViewMore: !enableSpecialActivity,
        );
      case const (LostFoundPostModel):
        return LostFoundPostView(
          lostFoundPostModel: socialPostModel as LostFoundPostModel,
          verticalPostView: verticalPostView,
          onReact: onReact,
          onComment: onComment,
          onVideoViewCount: onVideoViewCount,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
        );
      case const (PollPostModel):
        return PollPostView(
          pollPostModel: socialPostModel as PollPostModel,
          verticalPostView: verticalPostView,
          onReact: onReact,
          onComment: onComment,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
          disablePoll: !enableSpecialActivity,
        );
      case const (SafetyPostModel):
        return SafetyPostView(
          safetyPostModel: socialPostModel as SafetyPostModel,
          verticalPostView: verticalPostView,
          onComment: onComment,
          onReact: onReact,
          onVideoViewCount: onVideoViewCount,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
        );

      //Shared post view
      case const (SharedPostModel):
        return SharedPostView(
          sharedPostModel: socialPostModel as SharedPostModel,
          verticalPostView: verticalPostView,
          onReact: onReact,
          onComment: onComment,
          enableGroupHeaderView: enableGroupHeaderView,
          isSharedView: isSharedView,
        );
      default:
        throw ("Invalid post view format");
    }
  }
}
