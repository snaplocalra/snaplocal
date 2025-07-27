import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/post_share_dialog.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/shared_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/emoji_static_data.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/post_reaction_details_dialog.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/be_the_first_like.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/circular_counter.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';
import 'package:snap_local/common/utils/widgets/svg_button_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PostViewBottomWidget extends StatelessWidget {
  final PostFrom postFrom;
  final PostType postType;
  final PostReactionDetailsModel? postReactionDetails;
  final bool verticalPostView;
  final void Function(
    ReactionEmojiModel reactionEmojiModel,
    bool removeReaction,
  ) onReact;

  final int shareCount;
  final int commentCount;
  final bool allowComment;
  final bool allowShare;
  final bool isSharedView;
  final String postId;
  final void Function()? onCommentTap;
  final ReactionEmojiModel? reactionEmojiModel;
  const PostViewBottomWidget({
    super.key,
    this.onCommentTap,
    required this.onReact,
    required this.postId,
    required this.allowComment,
    required this.allowShare,
    this.postReactionDetails,
    required this.shareCount,
    required this.commentCount,
    required this.reactionEmojiModel,
    required this.postFrom,
    required this.postType,
    required this.verticalPostView,
    this.isSharedView = false,
  });

  @override
  Widget build(BuildContext context) {
    final reactionEmojiListModel = ReactionEmojiList.fromMap(emojiData);

    return BlocBuilder<GiveReactionCubit, GiveReactionState>(
      builder: (context, giveReactionState) {
        return Column(
          children: [
            //Post bottom details
            Padding(
              padding: const EdgeInsets.only(top: 3,left: 5,),
              child: Row(
                children: [
                  postReactionDetails != null
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PostReactionDetailsDialog(
                                postType: postType,
                                postId: postId,
                                postFrom: postFrom,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 18,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      //If the most used reaction list is more than or equal to 3, then the max length should be 3
                                      postReactionDetails!
                                                  .mostUsedEmojiList.length >=
                                              3
                                          ? 3
                                          : postReactionDetails!
                                              .mostUsedEmojiList.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(right: 1),
                                    child: SvgPicture.network(
                                      postReactionDetails!
                                          .mostUsedEmojiList[index].imageUrl,
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              CircularCounter(
                                number: postReactionDetails!.reactionCount,
                              ),
                            ],
                          ),
                        )
                      : BeTheFirstLike(
                          visible: reactionEmojiModel == null,
                          onTap: giveReactionState.isRequestLoading
                              ? null
                              : () {
                                  //Here in the list the 1st element is the LIKE reaction coming from the server.
                                  final likeReaction = reactionEmojiListModel
                                      .reactionEmojiList.first;
                                  onReact.call(likeReaction, false);
                                },
                        ),
                  const Spacer(),
                  Visibility(
                    visible: shareCount > 0,
                    child: Text(
                      "${shareCount.formatNumber()} ${shareCount <= 1 ? LocaleKeys.share : LocaleKeys.shares}",
                      style: const TextStyle(
                        color: Color.fromRGBO(101, 102, 104, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
           // const Divider(),
            Container(
              margin: EdgeInsets.only(top: 6),
              height: 0.5,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5),
            ),
            //Post bottom action
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.lightBlue.withOpacity(0.05),
                  border: Border(bottom: BorderSide(width: 5,color: Colors.grey.withOpacity(0.2)))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      reactionEmojiModel == null
                          ? SvgButtonTextWidget(
                              onLongPress: () {
                                context
                                    .read<ShowReactionCubit>()
                                    .showReactionEmojiOption(objectId: postId);
                              },
                              onTap: () {
                                //Here in the list the 1st element is the LIKE reaction coming from the server.
                                final likeReaction = reactionEmojiListModel.reactionEmojiList.first;
                                onReact.call(likeReaction, false);
                              },
                              svgImage: SVGAssetsImages.like,
                              svgColorFilter: ColorFilter.mode(
                                ApplicationColours.themePinkColor,
                                BlendMode.srcIn,
                              ),
                              svgHeight: 20,
                              svgWidth: 20,
                              text: tr(LocaleKeys.react),
                            )
                          : GestureDetector(
                              onLongPress: () {
                                context
                                    .read<ShowReactionCubit>()
                                    .showReactionEmojiOption(objectId: postId);
                              },
                              onTap: () async {
                                onReact.call(reactionEmojiModel!, true);
                              },
                              child: AbsorbPointer(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 20),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.network(
                                          reactionEmojiModel!.imageUrl,
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          reactionEmojiModel!.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: reactionEmojiModel!.nameColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      if (allowComment)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgButtonTextWidget(
                              onTap: onCommentTap,
                              text: tr(LocaleKeys.express),
                              svgImage: SVGAssetsImages.homecomment,
                              svgHeight: 20,
                              svgWidth: 20,
                              space: 4,
                            ),
                            Visibility(
                              visible: commentCount >= 1,
                              child: CircularCounter(number: commentCount),
                            )
                          ],
                        ),
                      if (allowShare)
                        SvgButtonTextWidget(
                          onTap: () {
                            //Show post share dialog
                            showDialog(
                              context: context,
                              builder: (_) {
                                late PostDetailsControllerCubit
                                    postDetailsControllerCubit;
                                if (postType == PostType.sharedPost) {
                                  final sharedPost = context
                                      .read<PostDetailsControllerCubit>()
                                      .state
                                      .socialPostModel as SharedPostModel;
                                  postDetailsControllerCubit =
                                      PostDetailsControllerCubit(
                                    socialPostModel: sharedPost.sharedPost,
                                  );
                                } else {
                                  postDetailsControllerCubit =
                                      context.read<PostDetailsControllerCubit>();
                                }

                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: postDetailsControllerCubit,
                                    ),
                                    //PostActionCubit
                                    BlocProvider.value(
                                      value: context.read<PostActionCubit>(),
                                    ),
                                    //ReportCubit
                                    BlocProvider.value(
                                      value: context.read<ReportCubit>(),
                                    ),
                                    // ShowReactionCubit
                                    BlocProvider.value(
                                      value: context.read<ShowReactionCubit>(),
                                    ),
                                  ],
                                  child: const SharePostDialog(),
                                );
                              },
                            );
                          },
                          text: tr(LocaleKeys.spread),
                          svgImage: SVGAssetsImages.shareArrow,
                          svgHeight: 20,
                          svgWidth: 20,
                        ),
                      if (allowShare)
                        SvgButtonTextWidget(
                          svgImage: SVGAssetsImages.whatsapp,
                          svgHeight: 25,
                          svgWidth: 25,
                          onTap: () async {
                            //Post details
                            final postModel = context
                                .read<PostDetailsControllerCubit>()
                                .state
                                .socialPostModel;

                            final sharePostLinkData = SharedPostDataModel(
                              postId: postModel.id,
                              postType: postModel.postType,
                              postFrom: postModel.postFrom,
                              shareType: ShareType.deepLink,
                            );

                            await context.read<ShareCubit>().shareOnWhatsApp(
                                  context,
                                  jsonData: sharePostLinkData.toJson(),
                                  screenURL:
                                      SharedSocialPostDetailsByLink.routeName,
                                  isEncrypted: true,
                                );
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
