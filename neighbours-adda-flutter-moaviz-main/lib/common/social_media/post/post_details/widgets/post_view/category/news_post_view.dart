import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/screen/news_post_view_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_category_time_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_post_short_heading.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/google_translate/widget/google_translate_text.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsPostView extends StatelessWidget {
  final bool verticalPostView,
      enableGroupHeaderView,
      isSharedView,
      hideViewMore;
  final void Function()? onComment;
  final void Function()? onVideoViewCount;
  final void Function(ReactionEmojiModel, bool) onReact;
  final NewsPostModel newsPostModel;
  final bool enableNewsPostAction;

  const NewsPostView({
    super.key,
    this.verticalPostView = false,
    required this.enableGroupHeaderView,
    this.isSharedView = false,
    this.hideViewMore = false,
    required this.onReact,
    required this.onComment,
    required this.newsPostModel,
    required this.enableNewsPostAction,
    required this.onVideoViewCount,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final postDetails = newsPostModel;
    final postReactionDetails = postDetails.postReactionDetailsModel;
    NetworkMediaModel? postMedia =
        postDetails.media.isEmpty ? null : postDetails.media[0];

    final applicationLanguage = context
        .watch<LanguageChangeControllerCubit>()
        .state
        .selectedLanguage
        .languageEnum;

    return BlocBuilder<NewsLanguageChangeControllerCubit,
        NewsLanguageChangeControllerState>(
      builder: (context, newsLanguageChangeControllerState) {
        return Container(
          decoration: BoxDecoration(
            color: isSharedView ? Colors.grey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Column(
                children: [
                  // post heading
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: NewsPostShortHeading(
                      newsPostModel: postDetails,
                      enableNewsPostAction: enableNewsPostAction,
                    ),
                  ),

                  //News content
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(235, 234, 234, 1),
                      ),
                      child: Column(
                        children: [
                          // post media
                          if (postMedia != null)
                            NetworkMediaWidget(
                              key: ValueKey(postMedia.mediaUrl),
                              media: postMedia,
                              height: 200,
                              onVideoViewCount: onVideoViewCount,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // category and time
                                    NewsCategoryTimeWidget(
                                      category: postDetails.category.name,
                                      createdAt: postDetails.createdAt,
                                    ),
                                    // headline
                                    GoogleTranslateText(
                                      text: newsPostModel.headline,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      targetLanguageCode:
                                          newsLanguageChangeControllerState
                                              .selectedLanguage
                                              .languageEnum
                                              .locale
                                              .languageCode,
                                      enableTranslation:
                                          newsLanguageChangeControllerState
                                              .enableTranslation,
                                    ),
                                  ],
                                ),
                              ),

                              // captions
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: GoogleTranslateText(
                                  text: newsPostModel.description,
                                  targetLanguageCode:
                                      newsLanguageChangeControllerState
                                          .selectedLanguage
                                          .languageEnum
                                          .locale
                                          .languageCode,
                                  enableTranslation:
                                      newsLanguageChangeControllerState
                                          .enableTranslation,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(52, 45, 45, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // View More button
                                    if (!hideViewMore)
                                      GestureDetector(
                                        onTap: () {
                                          GoRouter.of(context).pushNamed(
                                            NewsPostViewDetailsScreen.routeName,
                                            queryParameters: {
                                              'id': postDetails.id,
                                            },
                                            extra: {
                                              'postDetailsControllerCubit':
                                                  context.read<
                                                      PostDetailsControllerCubit>(),
                                              'showReactionCubit': context
                                                  .read<ShowReactionCubit>(),
                                              'postActionCubit': context
                                                  .read<PostActionCubit>(),
                                              'reportCubit':
                                                  context.read<ReportCubit>(),
                                              'commentViewControllerCubit':
                                                  context.read<
                                                      CommentViewControllerCubit>(),
                                              'hidePostCubit':
                                                  context.read<HidePostCubit>(),
                                            },
                                          );
                                        },
                                        child: Text(
                                          tr(LocaleKeys.viewMore).toUpperCase(),
                                          style: TextStyle(
                                            color: ApplicationColours
                                                .themeBlueColor,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: ApplicationColours
                                                .themeBlueColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                    //Translate to application set language
                                    Visibility(
                                      //If the news selected language is same as the application language then hide the translate button
                                      visible: applicationLanguage !=
                                          newsLanguageChangeControllerState
                                              .selectedLanguage.languageEnum,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<
                                                    NewsLanguageChangeControllerCubit>()
                                                .selectLanguage(
                                                    applicationLanguage);
                                          },
                                          child: Text(
                                            "Translate to ${applicationLanguage.nativeName}",
                                            style: TextStyle(
                                              color: ApplicationColours
                                                  .themeBlueColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ApplicationColours
                                                      .themeBlueColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // location
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          SVGAssetsImages.newsLocation,
                        ),
                      ),
                      Text(
                        newsPostModel.postLocation.address,
                        style: const TextStyle(
                          color: Color.fromRGBO(35, 32, 31, 1),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // like share comment
                  if (!isSharedView)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: PostViewBottomWidget(
                        key: ValueKey(postDetails.id),
                        verticalPostView: verticalPostView,
                        allowComment:
                            postDetails.postCommentPermission.allowComment,
                        allowShare: postDetails.postSharePermission.allowShare,
                        onCommentTap: onComment,
                        postId: postDetails.id,
                        shareCount: postDetails.shareCount,
                        commentCount: postDetails.commentCount,
                        reactionEmojiModel: postDetails.reactionEmojiModel,
                        postFrom: postDetails.postFrom,
                        postType: postDetails.postType,
                        postReactionDetails: postReactionDetails,
                        onReact: onReact,
                      ),
                    ),
                ],
              ),
              // Reaction box
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
        );
      },
    );
  }
}
