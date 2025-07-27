import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/video_feed/widgets/video_view.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import '../../../../utils/helper/profile_navigator.dart';
import '../../../../utils/hide/logic/hide_post/hide_post_cubit.dart';
import '../../../../utils/hide/repository/hide_post_repository.dart';
import '../../../../utils/post_action/logic/post_action/post_action_cubit.dart';
import '../../../../utils/post_action/repository/post_action_repository.dart';
import '../../../../utils/report/logic/report/report_cubit.dart';
import '../../../../utils/report/repository/report_repository.dart';
import '../../master_post/model/post_type_enum.dart';
import '../../modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import '../../modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import '../../modules/social_post_reaction/model/reaction_emoji_model.dart';
import '../../modules/social_post_reaction/repository/emoji_repository.dart';
import '../../post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import '../../post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import '../../post_details/models/post_from_enum.dart';
import '../../post_details/models/post_state_update/update_reaction_state.dart';


class VideoPageViewBuilder extends StatefulWidget {
  const VideoPageViewBuilder({
    super.key,
    this.socialPostsModel,
    this.hideEmptyPlaceHolder = false,
    this.socialPostList,
    this.physics,
    this.index,
    this.onPaginationDataFetch,
    this.visibilityDetectorKeyValue,
    this.padding,
    this.scrollController,
    this.allowNavigation = true,
    this.enableGroupHeaderView = true,
    this.closeReactionOnScroll = false,
    this.showBottomDivider = true,
    this.allowAction = true,
    this.onRemoveItemFromList,
    this.onRemoveByUnsaved,
    this.enableVisibilityPaginationDataCallBack = false,
    this.refreshParentData,
    this.hideBottomBarOnScroll = true,
    this.enableNewsPostAction = true,
    //required this.onCommentTap,
    //required this.onReact,
  });

  final SocialPostsList? socialPostsModel;
  final bool hideEmptyPlaceHolder;
  final List<SocialPostModel>? socialPostList;
  final void Function()? onPaginationDataFetch;
  //final void Function(SocialPostModel post) onCommentTap;
  //final void Function(SocialPostModel,ReactionEmojiModel, bool) onReact;
  final void Function(int index)? onRemoveItemFromList;
  final void Function(int index)? onRemoveByUnsaved;
  final String? visibilityDetectorKeyValue;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final int? index;

  ///If true then onPaginationDataFetch will call if the bottom widget visible
  final bool enableVisibilityPaginationDataCallBack;
  final EdgeInsetsGeometry? padding;

  //Actions
  final bool allowNavigation;
  final bool enableGroupHeaderView;
  final bool closeReactionOnScroll;
  final bool showBottomDivider;
  final bool allowAction;

  final void Function()? refreshParentData;

  //Bottom bar visibility on scroll
  final bool hideBottomBarOnScroll;

  //News post action
  final bool enableNewsPostAction;

  @override
  State<VideoPageViewBuilder> createState() => _VideoPageViewBuilderState();
}

class _VideoPageViewBuilderState extends State<VideoPageViewBuilder> {
  late final PageController _pageController;
  bool get paginationEnabled => widget.socialPostsModel != null;
  List<SocialPostModel> logs = [];

  // ShowReactionCubit showReactionCubit = ShowReactionCubit();
  // late GiveReactionCubit giveReactionCubit =
  // GiveReactionCubit(context.read<ReactionRepository>());
  //
  // void onReact({
  //   required ReactionEmojiModel reactionEmoji,
  //   bool removeReaction = false,
  //   required bool isFirstReaction,
  //   required String postId,
  //   required PostFrom postFrom,
  //   required PostType postType,
  // }) async {
  //   //Close the reaction option widget
  //   await context
  //       .read<ShowReactionCubit>()
  //       .closeReactionEmojiOption()
  //       .whenComplete(() async {
  //     if (!removeReaction) {
  //       HapticFeedback.lightImpact();
  //       // context.read<ReactionAudioEffectControllerCubit>().playReactionSound();
  //     }
  //
  //     //Reaction call back to update on the UI
  //     context
  //         .read<PostDetailsControllerCubit>()
  //         .postStateUpdate(UpdateReactionState(
  //       removeReaction ? null : reactionEmoji,
  //       isFirstReaction,
  //     ));
  //
  //     //Api call
  //     await giveReactionCubit.givePostReaction(
  //       postId: postId,
  //       postFrom: postFrom,
  //       postType: postType,
  //       reactionId: reactionEmoji.id,
  //     );
  //   });
  // }

  Future<void> profileNavigation({
    required String userId,
    required bool isOwnPost,
  }) async {
    //Close the reaction option widget before navigate to profile screen
    await context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() {
      if (mounted) {
        userProfileNavigation(context, userId: userId, isOwner: isOwnPost);
      }
    });
  }

  bool _validateWidget() {
    if (widget.socialPostList == null && widget.socialPostsModel == null) {
      throw ("No social media data model found");
    } else if (paginationEnabled &&
        (widget.enableVisibilityPaginationDataCallBack &&
            widget.visibilityDetectorKeyValue == null)) {
      throw ("Visibility Detector KeyValue not found");
    } else if (widget.enableVisibilityPaginationDataCallBack &&
        widget.onPaginationDataFetch == null) {
      throw ("When enableVisibilityPaginationDataCallBack is true then onPaginationDataFetch() showStarMark");
    } else {
      return true;
    }
  }

  void assignDataModel() {
    if (_validateWidget()) {
      if (widget.socialPostList != null) {
        logs = widget.socialPostList!;
      } else if (widget.socialPostsModel != null) {
        logs = widget.socialPostsModel!.socialPostList;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController=PageController(initialPage: widget.index??0);
    assignDataModel();

    if (widget.hideBottomBarOnScroll) {
      //Manage the bottom bar visibility on scroll
      ManageBottomBarVisibilityOnScroll(context).init(widget.scrollController);
    }
  }

  @override
  void didUpdateWidget(covariant VideoPageViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      assignDataModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (logs.isEmpty)
        ? widget.hideEmptyPlaceHolder
            ? SizedBox.shrink()
            : const Center(
                child: EmptyDataPlaceHolder(
                  emptyDataType: EmptyDataType.post,
                ),
              )
        : PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: paginationEnabled ? logs.length + 1 : logs.length,
      //onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        if (!paginationEnabled || index < logs.length) {
          //Post details
          final postDetails = logs[index];
          //Post Action cubit
          final postActionCubit = PostActionCubit(PostActionRepository());

          final postDetailsControllerCubit =
          PostDetailsControllerCubit(socialPostModel: postDetails);

          //Report cubit
          final reportCubit = ReportCubit(ReportRepository());

          //comment view controller cubit
          final commentViewControllerCubit = CommentViewControllerCubit();

          //Hide post cubit
          final HidePostCubit hidePostCubit =
          HidePostCubit(HidePostRepository());

          return MultiBlocProvider(
            key: ValueKey(postDetails.id),
            providers: [
              BlocProvider.value(value: postDetailsControllerCubit),
              BlocProvider.value(value: postActionCubit),
              BlocProvider.value(value: reportCubit),
              BlocProvider.value(value: commentViewControllerCubit),
              BlocProvider.value(value: hidePostCubit),
            ],
            child: Builder(builder: (context) {
              return BlocListener<PostDetailsControllerCubit,
                  PostDetailsControllerState>(
                listener: (context, postDetailsControllerState) {
                  if (postDetailsControllerState.removeItemFromList) {
                    widget.onRemoveItemFromList?.call(index);
                  } else if (postDetailsControllerState.removeByUnsaved) {
                    widget.onRemoveByUnsaved?.call(index);
                  }
                },
                child: VideoPlayerItem(
                  mediaUrl: postDetails.media.first.mediaUrl,
                  views: postDetails.media.first.views,
                  post: postDetails,
                 // onCommentTap: widget.onCommentTap,
                  //onReact: widget.onReact,
                  // onReact: (postDetails,reactionEmoji, removeReaction) {
                  //   onReact(
                  //     reactionEmoji: reactionEmoji,
                  //     isFirstReaction: postDetails.reactionEmojiModel == null,
                  //     postId: postDetails.id,
                  //     postFrom: postDetails.postFrom,
                  //     postType: postDetails.postType,
                  //     removeReaction: removeReaction,
                  //   );
                  // },
                  onProfileTap: (){
                    final postDetails=logs[index];
                    // if(widget.enableGroupHeaderView && ((postDetails.postFrom == PostFrom.group) && (postDetails.groupPageInfo != null))){
                    //   profileNavigation(
                    //     userId: postDetails.postUserInfo.userId,
                    //     isOwnPost: postDetails.isOwnPost,
                    //   );
                    // }
                    //else
                    if((postDetails.postFrom == PostFrom.page) && (postDetails.groupPageInfo != null)){
                      GoRouter.of(context).pushNamed(
                        PageDetailsScreen.routeName,
                        queryParameters: {
                          'id': postDetails.groupPageInfo!.id,
                        },
                      );
                    }
                    else{
                      profileNavigation(
                        userId: postDetails.postUserInfo.userId,
                        isOwnPost: postDetails.isOwnPost,
                      );
                    }
                  },
                ),
                // child: Column(children: [
                //   index == 0 ? demoWidget() : _buildPostWidget(index),
                // ]),
              );
            }),
          );

        }
        else {
          if (!widget.socialPostsModel!.paginationModel.isLastPage) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: widget.enableVisibilityPaginationDataCallBack
                  ? VisibilityDetector(
                key: Key(widget.visibilityDetectorKeyValue!),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage =
                      visibilityInfo.visibleFraction * 100;
                  if (visiblePercentage >= 60) {
                    if (widget.onPaginationDataFetch != null) {
                      widget.onPaginationDataFetch!.call();
                    }
                  }
                },
                child: const ThemeSpinner(size: 40),
              ) : const ThemeSpinner(size: 40),
            );
          }
        }
      },
    );
  }
}


