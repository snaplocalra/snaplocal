import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/safety_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_with_action.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_media_layout_builder.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_media_vertical_viewer.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SafetyPostView extends StatelessWidget {
  final SafetyPostModel safetyPostModel;
  final bool verticalPostView, enableGroupHeaderView, isSharedView;

  final void Function()? onVideoViewCount;
  final void Function()? onComment;
  final void Function(ReactionEmojiModel, bool) onReact;
  const SafetyPostView({
    super.key,

    ///true when the post view in the post share dialog
    this.isSharedView = false,
    required this.safetyPostModel,
    this.verticalPostView = false,
    required this.onReact,
    required this.onComment,
    required this.onVideoViewCount,
    required this.enableGroupHeaderView,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final postDetails = safetyPostModel;
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
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Tagged location
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
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
                          postDetails.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        //Post Caption
                        Visibility(
                          visible: postDetails.description.isNotEmpty,
                          child: ReadMoreText(
                            postDetails.description,
                            readMoreText: tr(LocaleKeys.readMore),
                            readLessText: tr(LocaleKeys.readLess),
                            style: const TextStyle(
                              color: Color.fromRGBO(52, 45, 45, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Post layout view
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

                  //if (verticalPostView)
                  if(postDetails.media.isNotEmpty)
                    PostMediaVerticalViewer(media: safetyPostModel.media,onVideoViewCount: onVideoViewCount,),

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

          //Post vertical view
          //if (verticalPostView)
           // PostMediaVerticalViewer(media: safetyPostModel.media),
        ],
      ),
    );
  }
}
