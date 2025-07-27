import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/screen/manage_group_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/screen/manage_event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/screen/manage_page_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/screens/manage_poll_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/lost_found_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/regular_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/safety_alerts_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/post_share_dialog.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_comment_permission_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_share_permission_state.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/constant/names.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class OwnerPostActionDialog extends StatelessWidget {
  final String postId;
  final String? groupPageInfoId;
  final PostFrom postFrom;
  final PostType postType;
  final PostCommentPermission postCommentPermission;
  final PostSharePermission postSharePermission;
  final bool showClosePoll;
  final bool allowEdit;
  const OwnerPostActionDialog({
    super.key,
    required this.postId,
    this.groupPageInfoId,
    required this.postFrom,
    required this.postType,
    required this.postCommentPermission,
    required this.postSharePermission,
    this.showClosePoll = false,
    this.allowEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    final allowComment = postCommentPermission.allowComment;
    final allowShare = postSharePermission.allowShare;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Close poll
            Visibility(
              visible: showClosePoll,
              child: ActionDialogOption(
                svgImage: SVGAssetsImages.closePoll,
                iconSize: 20,
                title: "Close poll",
                subtitle: "Restrict users from voting on this poll.",
                onTap: () {
                  //Api call
                  context
                      .read<PostActionCubit>()
                      .closePoll(postId: postId, postFrom: postFrom);
                },
              ),
            ),

            //Comment permission
            ActionDialogOption(
              svgImage: allowComment
                  ? SVGAssetsImages.disableComment
                  : SVGAssetsImages.enableComment,
              title: allowComment
                  ? tr(LocaleKeys.disableComments)
                  : tr(LocaleKeys.enableComments),
              subtitle: allowComment
                  ? tr(LocaleKeys.turnoffcommentsforthispost)
                  : tr(LocaleKeys.letotherscommentonyourpost),
              onTap: () {
                //Update the comment permission on ui
                context
                    .read<PostDetailsControllerCubit>()
                    .postStateUpdate(UpdateCommentPermissionState(
                      postCommentPermission.opposite,
                    ));

                //Api call
                context.read<PostActionCubit>().changeCommentPermission(
                      postId: postId,
                      postFrom: postFrom,
                      postType: postType,
                      postCommentPermission: postCommentPermission.opposite,
                    );
              },
            ),

            //Share permission
            ActionDialogOption(
              svgImage: allowShare
                  ? SVGAssetsImages.dontAllowSharing
                  : SVGAssetsImages.allowSharing,
              title: allowShare
                  ? tr(LocaleKeys.dontAllowSharing)
                  : tr(LocaleKeys.allowSharing),
              subtitle: allowShare
                  ? tr(LocaleKeys.preventsharingofthispost)
                  : tr(LocaleKeys.letotherscommentonyourpost),
              onTap: () {
                //Api call
                context.read<PostActionCubit>().changeSharePermission(
                      postId: postId,
                      postFrom: postFrom,
                      postType: postType,
                      postSharePermission: postSharePermission.opposite,
                    );

                //Update the share permission on ui
                context.read<PostDetailsControllerCubit>().postStateUpdate(
                    UpdateSharePermissionState(postSharePermission.opposite));
              },
            ),

            //Edit post
            if (allowEdit)
              ActionDialogOption(
                svgImage: SVGAssetsImages.edit,
                title: tr(LocaleKeys.edit),
                subtitle: tr(LocaleKeys.youcanedityourpost),
                onTap: () {
                  //Shared post
                  if (postType == PostType.sharedPost) {
                    showDialog(
                      context: context,
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                              value:
                                  context.read<PostDetailsControllerCubit>()),
                          BlocProvider.value(
                              value: context.read<PostActionCubit>()),
                          BlocProvider.value(
                              value: context.read<ReportCubit>()),
                          BlocProvider.value(
                            value: context.read<ShowReactionCubit>(),
                          ),
                        ],
                        child: const UpdateSocialPostDialog(),
                      ),
                    );
                  } else {
                    //Regular post
                    if (postType == PostType.askQuestion ||
                        postType == PostType.askSuggestion ||
                        postType == PostType.general) {
                      if (postFrom == PostFrom.feed) {
                        GoRouter.of(context)
                            .pushNamed(RegularPostScreen.routeName, extra: {
                          "postDetailsControllerCubit":
                              context.read<PostDetailsControllerCubit>(),
                          "postType": postType,
                        });
                      }
                      else if (postFrom == PostFrom.group) {
                        if (groupPageInfoId == null) {
                          throw "Group id is null";
                        }
                        GoRouter.of(context).pushNamed(
                          ManageGroupPostScreen.routeName,
                          queryParameters: {'group_id': groupPageInfoId},
                          extra: context.read<PostDetailsControllerCubit>(),
                        );
                      }
                      else if (postFrom == PostFrom.page) {
                        if (groupPageInfoId == null) {
                          throw "Page id is null";
                        }
                        GoRouter.of(context).pushNamed(
                          ManagePagePostScreen.routeName,
                          queryParameters: {'page_id': groupPageInfoId},
                          extra: context.read<PostDetailsControllerCubit>(),
                        );
                      }
                    }
                    else {
                      //Other post
                      late String screenName;

                      //Extract the screen name
                      switch (postType) {
                        case PostType.event:
                          screenName = CreateEventScreen.routeName;
                          break;
                        case PostType.poll:
                          screenName = ManagePollScreen.routeName;
                          break;
                        case PostType.lostFound:
                          screenName = LostFoundPostScreen.routeName;
                          break;
                        case PostType.safety:
                          screenName = SafetyAlertPostScreen.routeName;
                          break;
                        default:
                          throw "Invalid post type";
                      }

                      //Navigate to the assigned screen
                      GoRouter.of(context).pushNamed(
                        screenName,
                        extra: context.read<PostDetailsControllerCubit>(),
                      );
                    }
                  }
                },
              ),

            //Delete post
            ActionDialogOption(
              showdivider: false,
              svgImage: SVGAssetsImages.delete,
              title: tr(LocaleKeys.delete),
              subtitle: tr(LocaleKeys.youcandeleteyourpost),
              onTap: () async {
                final postActionCubit = context.read<PostActionCubit>();
                await showConfirmationDialog(
                  context,
                  confirmationButtonText: tr(LocaleKeys.delete),
                  message:
                      'Are you sure you want to permanently remove this post from $applicationName?',
                ).then((allowDelete) {
                  if (allowDelete != null && allowDelete) {
                    //Api call
                    postActionCubit.deleteSocialPost(
                      postId: postId,
                      postFrom: postFrom,
                      postType: postType,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserPostActionDialog extends StatelessWidget {
  final String postId;
  final String? groupPageInfoId;
  final String userId;
  final PostFrom postFrom;
  final PostType postType;
  const UserPostActionDialog({
    super.key,
    required this.postId,
    required this.groupPageInfoId,
    required this.userId,
    required this.postFrom,
    required this.postType,
  });

  ReportType getReportType() {
    ReportType reportType = ReportType.regularPost;

    //Check for poll and event
    if (postType == PostType.poll) {
      reportType = ReportType.poll;
    } else if (postType == PostType.event) {
      reportType = ReportType.event;
    }
    return reportType;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionDialogOption(
              svgImage: SVGAssetsImages.report,
              title: tr(LocaleKeys.report),
              subtitle: tr(LocaleKeys.flagForReview),
              onTap: () {
                GoRouter.of(context).pushNamed(
                  ReportScreen.routeName,
                  extra: SocialPostReportPayload(
                    postId: postId,
                    reportType: getReportType(),
                    postFrom: postFrom,
                    postType: postType,
                    reportCubit: context.read<ReportCubit>(),
                  ),
                );
              },
            ),
            ActionDialogOption(
              iconSize: 15,
              showdivider: false,
              svgImage: SVGAssetsImages.eyeClose,
              title: tr(LocaleKeys.hide),
              subtitle: tr(LocaleKeys.removeFromFeed),
              onTap: () async {
                final hideCubit = context.read<HidePostCubit>();
                await showConfirmationDialog(
                  context,
                  confirmationButtonText: tr(LocaleKeys.hide),
                  message:
                      'Are you sure you want to hide this post from $applicationName?',
                ).then((allowDelete) {
                  if (allowDelete != null && allowDelete) {
                    hideCubit.hidetSocialPostReport(
                      postId: postId,
                      postFrom: postFrom,
                      postType: postType,
                      reportType: getReportType(),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
