// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/post_action_3_dot_button_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_action_permission.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_close_poll_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_comment_permission_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_save_status_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_share_permission_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/group_post_heading_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_widget.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/home_route.dart';
import 'package:snap_local/profile/profile_level/widget/level_badge_widget.dart';
import 'package:snap_local/utility/common/widgets/custom_tool_tip.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/router/check_current_route.dart';

import 'official_post_heading_widget.dart';

class PostHeadingWithActions extends StatefulWidget {
  const PostHeadingWithActions({
    super.key,
    required this.postDetails,
    required this.verticalPostView,
    required this.enableGroupHeaderView,
    this.isSharedView = false,
  });

  final SocialPostModel postDetails;
  final bool verticalPostView;
  final bool enableGroupHeaderView;
  final bool isSharedView;

  @override
  State<PostHeadingWithActions> createState() => _PostHeadingWithActionsState();
}

class _PostHeadingWithActionsState extends State<PostHeadingWithActions> {
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

  void removeFromList() {
    context.read<CommentViewControllerCubit>().disableCommentView();
    context.read<ShowReactionCubit>().closeReactionEmojiOption();
    if (widget.verticalPostView && GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      context.read<PostDetailsControllerCubit>().removeItemFromList();
    }
  }



  @override
  Widget build(BuildContext context) {
    Color color=Colors.white;
    if(widget.postDetails.postType==PostType.sharedPost){
      final hex = widget.postDetails.postUserInfo.colorCode.replaceFirst('#', '') ?? 'FFFFFF';
      color = Color(int.parse('0xFF$hex'));
    }
    else{
      final hex = widget.postDetails.postUserInfo.levelBadgeModel?.color.replaceFirst('#', '') ?? 'FFFFFF';
      color = Color(int.parse('0xFF$hex'));
    }
    print("==========================================================");
    print(widget.postDetails.toMap());
    return Container(
      padding: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(1.0),
            color.withOpacity(0.7),
            color.withOpacity(0.5),
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.enableGroupHeaderView && ((widget.postDetails.postFrom == PostFrom.group) && (widget.postDetails.groupPageInfo != null))
                  ? GroupPostHeadingWidget(
                      onProfileTap: () {
                        profileNavigation(
                          userId: widget.postDetails.postUserInfo.userId,
                          isOwnPost: widget.postDetails.isOwnPost,
                        );
                      },
                      onGroupProfileTap: () {
                        GoRouter.of(context).pushNamed(
                          GroupDetailsScreen.routeName,
                          queryParameters: {
                            'id': widget.postDetails.groupPageInfo!.id,
                          },
                        );
                      },
                      groupPostPrivacy:
                          widget.postDetails.postVisibilityPermission,
                      groupName: widget.postDetails.groupPageInfo!.name,
                      isVerified: widget.postDetails.groupPageInfo!.isVerified,
                      groupImageUrl: widget.postDetails.groupPageInfo!.image,
                      userName: widget.postDetails.postUserInfo.userName,
                      address: widget.postDetails.postLocation.address,
                      userImageUrl: widget.postDetails.postUserInfo.userImage,
                      postType: widget.postDetails.groupPageInfo!.category
                          .subCategoryString(),
                      userType: widget.postDetails.postUserInfo.userType,

                createdAt: widget.postDetails.createdAt,
                      onPostTypeTap: widget.postDetails is PostTypeNavigation &&
                              //only allow navigation if the current route is home
                              checkRoute(context, HomeRoute.routeName)
                          ? () {
                              (widget.postDetails as PostTypeNavigation).navigateToPostTypeModule(context);
                            }
                          : null,
                    )
                  : ((widget.postDetails.postFrom == PostFrom.page) &&
                          (widget.postDetails.groupPageInfo != null))
                      ? PostHeadingWidget(
                isVerified: widget.postDetails.postUserInfo.isVerified,
                          levelBadgeModel: widget.postDetails.postUserInfo.levelBadgeModel,
                          complimentBadgeModel: widget.postDetails.postUserInfo.complimentBadgeModel,
                          onProfileTap: () {
                            GoRouter.of(context).pushNamed(
                              PageDetailsScreen.routeName,
                              queryParameters: {
                                'id': widget.postDetails.groupPageInfo!.id,
                              },
                            );
                          },
                          createdAt: widget.postDetails.createdAt,
                          title: widget.postDetails.groupPageInfo!.name,
                          address: widget.postDetails.postLocation.address,
                          imageUrl: widget.postDetails.groupPageInfo!.image,
                          postType: widget.postDetails.groupPageInfo!.category
                              .subCategoryString(),
                          userType: widget.postDetails.postUserInfo.userType,

                postPrivacy:
                              widget.postDetails.postVisibilityPermission,
                          onPostTypeTap: widget.postDetails
                                      is PostTypeNavigation &&
                                  //only allow navigation if the current route is home
                                  checkRoute(context, HomeRoute.routeName)
                              ? () {
                                  (widget.postDetails as PostTypeNavigation)
                                      .navigateToPostTypeModule(context);
                                }
                              : null,
                        )
              //     : widget.postDetails.postType == PostType.officialPost
              //         ? OfficialPostHeadingWidget(
              //   complimentBadgeModel: widget
              //       .postDetails.postUserInfo.complimentBadgeModel,
              //   onProfileTap: () {
              //     profileNavigation(
              //       userId: widget.postDetails.postUserInfo.userId,
              //       isOwnPost: widget.postDetails.isOwnPost,
              //     );
              //   },
              //   postPrivacy:
              //   widget.postDetails.postVisibilityPermission,
              //   title: widget.postDetails.postUserInfo.userName.split(" "),
              //   address: widget.postDetails.postLocation.address,
              //   imageUrl: widget.postDetails.postUserInfo.userImage,
              //   postType: tr(widget.postDetails.postType.displayText),
              //   createdAt: widget.postDetails.createdAt,
              //   onPostTypeTap: widget.postDetails
              //   is PostTypeNavigation &&
              //       //only allow navigation if the current route is home
              //       checkRoute(context, HomeRoute.routeName)
              //       ? () {
              //     (widget.postDetails as PostTypeNavigation)
              //         .navigateToPostTypeModule(context);
              //   }
              //       : null,
              // )
                      : PostHeadingWidget(
                          levelBadgeModel: widget.postDetails.postUserInfo.levelBadgeModel,
                          complimentBadgeModel: widget.postDetails.postUserInfo.complimentBadgeModel,
                          onProfileTap: () {
                            profileNavigation(
                              userId: widget.postDetails.postUserInfo.userId,
                              isOwnPost: widget.postDetails.isOwnPost,
                            );
                          },
                          postPrivacy:
                              widget.postDetails.postVisibilityPermission,
                          title: widget.postDetails.postUserInfo.userName,
                          isVerified: widget.postDetails.postUserInfo.isVerified,

                          address: widget.postDetails.postLocation.address,
                          imageUrl: widget.postDetails.postUserInfo.userImage,
                          postType: tr(widget.postDetails.postType.displayText),
                          userType: widget.postDetails.postUserInfo.userType,

                createdAt: widget.postDetails.createdAt,
                          onPostTypeTap: widget.postDetails
                                      is PostTypeNavigation &&
                                  //only allow navigation if the current route is home
                                  checkRoute(context, HomeRoute.routeName)
                              ? () {
                                  (widget.postDetails as PostTypeNavigation)
                                      .navigateToPostTypeModule(context);
                                }
                              : null,
                        ),
            ),

            //Book mark
            if (!widget.isSharedView)
              BlocConsumer<PostActionCubit, PostActionState>(
                listener: (context, postActionState) {
                  if (postActionState.isRequestFailed) {
                    //Reverse the status
                    context.read<PostDetailsControllerCubit>().postStateUpdate(
                        UpdateSaveStatusState(!widget.postDetails.isSaved));
                  }
                },
                builder: (context, postActionState) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: CustomToolTip(
                      message: widget.postDetails.isSaved
                          ? "Added in saved item"
                          : "Removed from saved item",
                      child: SvgButtonWidget(
                        svgImage: widget.postDetails.isSaved
                            ? SVGAssetsImages.saved
                            : SVGAssetsImages.unSaved,
                        onTap: postActionState.isSaveRequestLoading
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                context
                                    .read<PostActionCubit>()
                                    .saveUnsaveSocialPost(
                                      postId: widget.postDetails.id,
                                      postFrom: widget.postDetails.postFrom,
                                      postType: widget.postDetails.postType,
                                    );
                                //Update on the UI
                                context
                                    .read<PostDetailsControllerCubit>()
                                    .postStateUpdate(UpdateSaveStatusState(
                                        !widget.postDetails.isSaved));
                              },
                      ),
                    ),
                  );
                },
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //More action
                if (!widget.isSharedView)
                  BlocListener<HidePostCubit, HidePostState>(
                    listener: (context, hidePostState) {
                      if (hidePostState.requestLoading) {
                        removeFromList();
                      }
                    },
                    child: BlocListener<ReportCubit, ReportState>(
                      listener: (context, reportState) {
                        //Remove item from list if report success
                        if (reportState.requestSuccess) {
                          removeFromList();
                        }
                      },
                      child: BlocListener<PostActionCubit, PostActionState>(
                        listener: (context, postActionState) {
                          if (postActionState.isClosePollRequestLoading) {
                            context
                                .read<PostDetailsControllerCubit>()
                                .postStateUpdate(UpdateClosePollState(true));
                          } else if (postActionState.isDeleteRequestLoading) {
                            removeFromList();
                          } else if (postActionState.isChangeShareRequestFailed) {
                            //On failer reverse the status
                            context
                                .read<PostDetailsControllerCubit>()
                                .postStateUpdate(UpdateSharePermissionState(
                                  widget.postDetails.postSharePermission.opposite,
                                ));
                          } else if (postActionState
                              .isChangeCommentRequestFailed) {
                            //On failer reverse the status
                            context
                                .read<PostDetailsControllerCubit>()
                                .postStateUpdate(UpdateCommentPermissionState(
                                  widget
                                      .postDetails.postCommentPermission.opposite,
                                ));
                          }
                        },
                        child: SvgButtonWidget(
                          svgImage: SVGAssetsImages.moreDot,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => PostAction3DotButtonWidget()
                                  .build(context, widget.postDetails),
                            );
                          },
                          svgSize: 28,
                        ),
                      ),
                    ),
                  ),

                //Level badge
                if (widget.postDetails.postUserInfo.levelBadgeModel != null&&widget.postDetails.postUserInfo.userType!="official")
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: LevelBadgeWidget(
                      levelBadgeModel:
                          widget.postDetails.postUserInfo.levelBadgeModel!,
                      isOfficialUser: false,
                      userId: widget.postDetails.postUserInfo.userId,
                      size: 22,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
