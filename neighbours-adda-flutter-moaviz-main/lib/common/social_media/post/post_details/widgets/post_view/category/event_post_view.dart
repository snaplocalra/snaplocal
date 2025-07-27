import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_details_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_with_action.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_media_layout_builder.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_media_vertical_viewer.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class EventPostView extends StatelessWidget {
  final bool verticalPostView,
      enableGroupHeaderView,
      isSharedView,
      hideViewMore;
  final void Function()? onComment;
  final void Function()? onVideoViewCount;
  final void Function(ReactionEmojiModel, bool) onReact;

  final EventPostModel eventPostModel;

  const EventPostView({
    super.key,
    this.verticalPostView = false,
    this.isSharedView = false,
    this.hideViewMore = false,
    required this.enableGroupHeaderView,
    required this.onReact,
    required this.onComment,
    required this.onVideoViewCount,
    required this.eventPostModel,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final postDetails = eventPostModel;
    final postReactionDetails = postDetails.postReactionDetailsModel;
    return Container(
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
            postDetails: postDetails,
            verticalPostView: verticalPostView,
            enableGroupHeaderView: enableGroupHeaderView,
          ),

          //Body
          //Stack is used to carry the reaction widget to open on the post
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Tagged location
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: AddressWithLocationIconWidget(
                            iconSize: 14,
                            iconTopPadding: 1,
                            fontSize: 11,
                            iconColour: ApplicationColours.themePinkColor,
                            textColour: ApplicationColours.themeBlueColor,
                            address: postDetails.taggedlocation!.address,
                            latitude: postDetails.taggedlocation!.latitude,
                            longitude: postDetails.taggedlocation!.longitude,
                            enableOpeningMap: !isSharedView,
                          ),
                        ),
                        Text(
                          postDetails.eventShortDetails.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  "${FormatDate.formatDateTimeWithTimeOfDayDTMMM(
                                    postDetails.eventShortDetails.startDate,
                                    postDetails.eventShortDetails.startTime,
                                  )} - ${FormatDate.formatDateTimeWithTimeOfDayDTMMM(
                                    postDetails.eventShortDetails.endDate,
                                    postDetails.eventShortDetails.endTime,
                                  )}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (!hideViewMore)
                              InkWell(
                                onTap: () {
                                  GoRouter.of(context).pushNamed(
                                      EventDetailsScreen.routeName,
                                      queryParameters: {
                                        'id': postDetails.id
                                      },
                                      extra: {
                                        'postActionCubit':
                                            context.read<PostActionCubit>(),
                                        'postDetailsControllerCubit': context
                                            .read<PostDetailsControllerCubit>(),
                                      });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(112, 112, 112, 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    tr(LocaleKeys.viewMore).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // //Post layout view
                  // if (!verticalPostView)
                  //   Visibility(
                  //     visible: postDetails.media.isNotEmpty,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 5),
                  //       child: PostMediaLayoutBuilder(
                  //         mediaList: postDetails.media,
                  //       ),
                  //     ),
                  //   ),

                  // Post vertical view
                  //if (verticalPostView)
                  if(postDetails.media.isNotEmpty)
                  PostMediaVerticalViewer(media: eventPostModel.media,onVideoViewCount: onVideoViewCount,),

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
                            postDetails.postCommentPermission.allowComment,
                        allowShare: postDetails.postSharePermission.allowShare,
                        onCommentTap: onComment,
                        postId: postDetails.id,
                        postType: postDetails.postType,
                        shareCount: postDetails.shareCount,
                        commentCount: postDetails.commentCount,
                        reactionEmojiModel: postDetails.reactionEmojiModel,
                        postFrom: postDetails.postFrom,
                        postReactionDetails: postReactionDetails,
                        onReact: onReact,
                      ),
                    ),
                ],
              ),

              //Reaction box
              if (!isSharedView)
                BlocBuilder<ShowReactionCubit, ShowReactionState>(
                  builder: (context, showReactionState) {
                    return Visibility(
                      visible: showReactionState.showEmojiOption &&
                          showReactionState.objectId == postDetails.id,
                      child: Positioned(
                        bottom: mqSize.height * 0.02,
                        right: 0,
                        left: 0,
                        child: ReactionWidget(
                          postId: postDetails.id,
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

          // Post vertical view
          //if (verticalPostView)
            //PostMediaVerticalViewer(media: eventPostModel.media)
        ],
      ),
    );
  }
}
