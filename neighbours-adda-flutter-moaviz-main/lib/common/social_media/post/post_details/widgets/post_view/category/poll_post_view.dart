// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/poll_vote_manage/poll_vote_manage_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/polls_list/polls_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_service/poll_service_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/repository/manage_poll_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/poll_post_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_with_action.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/screen/analytics_overview_screen.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PollPostView extends StatelessWidget {
  final PollPostModel pollPostModel;
  final bool verticalPostView, enableGroupHeaderView, isSharedView, disablePoll;
  final void Function()? onComment;
  final void Function(ReactionEmojiModel, bool) onReact;
  const PollPostView({
    super.key,

    ///true when the post view in the post share dialog
    this.isSharedView = false,
    this.verticalPostView = false,
    this.disablePoll = false,
    required this.enableGroupHeaderView,
    required this.onReact,
    required this.onComment,
    required this.pollPostModel,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final postReactionDetails = pollPostModel.postReactionDetailsModel;
    return Container(
      key: Key(pollPostModel.id),
      decoration: BoxDecoration(
        color: isSharedView ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Post header
          PostHeadingWithActions(
            isSharedView: isSharedView,
            postDetails: pollPostModel,
            verticalPostView: verticalPostView,
            enableGroupHeaderView: enableGroupHeaderView,
          ),

          //Body
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => PollServiceCubit(
                          managePollRepository: ManagePollRepository(),
                          mediaUploadRepository:
                              context.read<MediaUploadRepository>(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => PollVoteManageCubit(
                          pollPostModel: pollPostModel,
                          pollServiceCubit: context.read<PollServiceCubit>(),
                        ),
                      ),
                    ],
                    child: PollPostWidget(
                      pollPostModel: pollPostModel,
                      disablePoll: disablePoll,
                      onDataRefreshCallBack: (targetPollsListType) {
                        context.read<PollsListCubit>().fetchPolls();
                      },
                    ),
                  ),

                  //Post bottom details
                  if (!isSharedView)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: PostViewBottomWidget(
                        verticalPostView: verticalPostView,
                        allowComment:
                            pollPostModel.postCommentPermission.allowComment,
                        allowShare:
                            pollPostModel.postSharePermission.allowShare,
                        onCommentTap: onComment,
                        postId: pollPostModel.id,
                        postType: pollPostModel.postType,
                        shareCount: pollPostModel.shareCount,
                        commentCount: pollPostModel.commentCount,
                        reactionEmojiModel: pollPostModel.reactionEmojiModel,
                        postFrom: pollPostModel.postFrom,
                        postReactionDetails: postReactionDetails,
                        onReact: onReact,
                      ),
                    ),

                  //Post analytics text button
                  if (pollPostModel.isOwnPost)
                    Column(
                      children: [
                        const Divider(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 2),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  AnalyticsOverviewScreen.routeName,
                                  queryParameters: {
                                    'module_id': pollPostModel.id,
                                    'module_type':
                                        AnalyticsModuleType.poll.jsonValue,
                                  },
                                );
                              },
                              child: Text(
                                "View Analytics",
                                style: TextStyle(
                                  color: ApplicationColours.themeBlueColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              //Reaction box
              if (!isSharedView)
                BlocBuilder<ShowReactionCubit, ShowReactionState>(
                  builder: (context, showReactionState) {
                    return Visibility(
                      visible: showReactionState.showEmojiOption &&
                          showReactionState.objectId == pollPostModel.id,
                      child: Positioned(
                        bottom: mqSize.height * 0.02,
                        right: 0,
                        left: 0,
                        child: ReactionWidget(
                          postId: pollPostModel.id,
                          onReact: (reaction) async {
                            onReact.call(reaction, false);
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
