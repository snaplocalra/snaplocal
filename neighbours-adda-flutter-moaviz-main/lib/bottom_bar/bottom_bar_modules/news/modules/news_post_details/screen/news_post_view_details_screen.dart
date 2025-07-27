import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/logic/news_post_details/news_post_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/repository/news_post_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_category_time_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_language_change_popup.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_post_channel_profile_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_actions/comment_actions_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reaction_box_hide_controller/comment_reaction_box_hide_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reply_status_controller/comment_reply_status_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/send_comment/send_comment_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/comment_builder.dart';
import 'package:snap_local/common/social_media/post/modules/comment/widgets/send_comment_widget.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_reaction_state.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_save_status_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/network_media_carousels_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/google_translate/widget/google_translate_text.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class NewsPostViewDetailsScreen extends StatefulWidget {
  final String postId;
  final PostDetailsControllerCubit? existingPostDetailsControllerCubit;
  static const routeName = 'news_post_view';

  const NewsPostViewDetailsScreen({
    super.key,
    required this.postId,
    required this.existingPostDetailsControllerCubit,
  });

  @override
  State<NewsPostViewDetailsScreen> createState() =>
      _NewsPostViewDetailsScreenState();
}

class _NewsPostViewDetailsScreenState extends State<NewsPostViewDetailsScreen> {
  final postViewScrollController = ScrollController();

  late final NewsPostDetailsCubit newsPostDetailsCubit =
      NewsPostDetailsCubit(NewsPostDetailsRepository());

  late PostDetailsControllerCubit postDetailsControllerCubit;

  //Comment controller
  final commentFocusNode = FocusNode();
  final commentController = TextEditingController();
  final commentReactionBoxHideControllerCubit =
      CommentReactionBoxHideControllerCubit();

  @override
  void dispose() {
    commentFocusNode.dispose();
    commentController.dispose();
    postViewScrollController.dispose();
    super.dispose();
  }

  void onReact({
    required ReactionEmojiModel reactionEmoji,
    bool removeReaction = false,
    required bool isFirstReaction,
    required String postId,
    required PostDetailsControllerCubit postDetailsControllerCubit,
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
      if (mounted) {
        //Reaction call back to update on the UI
        postDetailsControllerCubit.postStateUpdate(UpdateReactionState(
          removeReaction ? null : reactionEmoji,
          isFirstReaction,
        ));

        //Api call
        await context.read<GiveReactionCubit>().givePostReaction(
              postId: postId,
              postFrom: PostFrom.news,
              postType: PostType.newsPost,
              reactionId: reactionEmoji.id,
            );
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    newsPostDetailsCubit.loadNewsPostDetails(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          //Close the reaction option widget
          context.read<ShowReactionCubit>().closeReactionEmojiOption();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: newsPostDetailsCubit),
          BlocProvider(
            create: (context) => CommentReplyStatusControllerCubit(
              ownerName: context
                  .read<ManageProfileDetailsBloc>()
                  .state
                  .profileDetailsModel!
                  .name,
            ),
          ),
          BlocProvider.value(value: commentReactionBoxHideControllerCubit),
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
        child: Scaffold(
          appBar: ThemeAppBar(
            showBackButton: true,
            backgroundColor: Colors.white,
            titleSpacing: 6,
            appBarHeight: 50,
            title: Text(
              tr(LocaleKeys.newsDetails),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 18,
              ),
            ),
          ),
          body: BlocConsumer<NewsPostDetailsCubit, NewsPostDetailsState>(
            listener: (context, newsPostDetailsState) {
              if (newsPostDetailsState is NewsPostDetailsLoaded) {
                if (widget.existingPostDetailsControllerCubit != null) {
                  //Assign the existing post details controller cubit to the new post details controller cubit
                  postDetailsControllerCubit =
                      widget.existingPostDetailsControllerCubit!;

                  //Update the post state with the new post details
                  postDetailsControllerCubit.postStateUpdate(
                      UpdatePostState(newsPostDetailsState.newsPost));
                } else {
                  //Create a new post details controller cubit
                  postDetailsControllerCubit = PostDetailsControllerCubit(
                    socialPostModel: newsPostDetailsState.newsPost,
                  );
                }
              }
            },
            builder: (context, newsPostDetailsState) {
              if (newsPostDetailsState is NewsPostDetailsError) {
                return ErrorTextWidget(
                  error: newsPostDetailsState.message,
                );
              } else if (newsPostDetailsState is NewsPostDetailsLoaded) {
                return BlocProvider.value(
                  value: postDetailsControllerCubit,
                  child: BlocBuilder<PostDetailsControllerCubit,
                      PostDetailsControllerState>(
                    builder: (context, postDetailsControllerState) {
                      final newsPostModel = postDetailsControllerState
                          .socialPostModel as NewsPostModel;
                      return BlocListener<PostActionCubit, PostActionState>(
                        listener: (context, postActionState) {
                          if (postActionState.isDeleteRequestLoading &&
                              GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          }
                          // //Update the external PostDetailsControllerCubit
                          // else if (postActionState.isFollowRequestLoading) {
                          //   widget.existingPostDetailsControllerCubit
                          //       ?.postStateUpdate(
                          //     UpdateNewsChannelFollowState(
                          //       isFollowed:
                          //           newsPostModel.newsChannelInfo.isFollowing,
                          //     ),
                          //   );
                          // } else if (postActionState.isSharePermissionLoading) {
                          //   widget.existingPostDetailsControllerCubit
                          //       ?.postStateUpdate(UpdateSharePermissionState(
                          //     newsPostModel.postSharePermission,
                          //   ));
                          // } else if (postActionState
                          //     .isCommentPermissionLoading) {
                          //   widget.existingPostDetailsControllerCubit
                          //       ?.postStateUpdate(UpdateCommentPermissionState(
                          //     newsPostModel.postCommentPermission,
                          //   ));
                          // }
                          //
                        },
                        child: BlocListener<HidePostCubit, HidePostState>(
                          listener: (context, hidePostState) {
                            if (hidePostState.requestLoading &&
                                GoRouter.of(context).canPop()) {
                              GoRouter.of(context).pop();
                            }
                          },
                          child: BlocListener<ReportCubit, ReportState>(
                            listener: (context, reportState) {
                              //Remove item from list if report success
                              if (reportState.requestSuccess &&
                                  GoRouter.of(context).canPop()) {
                                GoRouter.of(context).pop();
                              }
                            },
                            child: BlocConsumer<CommentViewControllerCubit,
                                CommentViewControllerState>(
                              listener: (context, commentViewControllerState) {
                                if (commentViewControllerState.enableComment) {
                                  requestFocusOnComment();
                                }
                              },
                              builder: (context, commentViewControllerState) {
                                return BlocBuilder<
                                    NewsLanguageChangeControllerCubit,
                                    NewsLanguageChangeControllerState>(
                                  builder: (context,
                                      newsLanguageChangeControllerState) {
                                    return Column(children: [
                                      Expanded(
                                        child: ListView(
                                          controller: postViewScrollController,
                                          children: [
                                            //News post content
                                            Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Divider(
                                                        thickness: 4,
                                                        color: Color.fromRGBO(
                                                            239, 239, 239, 1),
                                                      ),
                                                      // heading
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          //mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // headline
                                                            GoogleTranslateText(
                                                              text:
                                                                  newsPostModel
                                                                      .headline,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Posted on ${FormatDate.ddMMampm(newsPostModel.createdAt)} IST",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            35,
                                                                            32,
                                                                            31,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Row(
                                                                  children: [
                                                                    BlocBuilder<
                                                                        PostActionCubit,
                                                                        PostActionState>(
                                                                      builder:
                                                                          (context,
                                                                              postActionState) {
                                                                        return CircularSvgButton(
                                                                          svgImage: newsPostModel.isSaved
                                                                              ? SVGAssetsImages.saved
                                                                              : SVGAssetsImages.unSaved,
                                                                          iconColor:
                                                                              Colors.white,
                                                                          backgroundColor:
                                                                              ApplicationColours.themeLightPinkColor,
                                                                          onTap: postActionState.isSaveRequestLoading
                                                                              ? null
                                                                              : () {
                                                                                  context.read<PostActionCubit>().saveUnsaveSocialPost(
                                                                                        postId: newsPostModel.id,
                                                                                        postFrom: newsPostModel.postFrom,
                                                                                        postType: newsPostModel.postType,
                                                                                      );
                                                                                  //Update on the UI
                                                                                  context.read<PostDetailsControllerCubit>().postStateUpdate(
                                                                                        UpdateSaveStatusState(
                                                                                          !newsPostModel.isSaved,
                                                                                        ),
                                                                                      );
                                                                                },
                                                                        );
                                                                      },
                                                                    ),

                                                                    AnimatedHideWidget(
                                                                      visible: newsPostModel
                                                                          .postSharePermission
                                                                          .allowShare,
                                                                      child:
                                                                          CircularSvgButton(
                                                                        iconSize:
                                                                            16,
                                                                        svgImage:
                                                                            SVGAssetsImages.share,
                                                                        iconColor:
                                                                            Colors.white,
                                                                        backgroundColor:
                                                                            ApplicationColours.themeLightPinkColor,
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .read<ShareCubit>()
                                                                              .generalShare(
                                                                                context,
                                                                                data: widget.postId,
                                                                                screenURL: NewsPostViewDetailsScreen.routeName,
                                                                                shareSubject: "Share this news post",
                                                                              );
                                                                        },
                                                                      ),
                                                                    ),

                                                                    //popup menu
                                                                    NewsLanguageChangePopUp(
                                                                      child:
                                                                          CircularSvg(
                                                                        iconSize:
                                                                            45,
                                                                        svgImage:
                                                                            SVGAssetsImages.translate,
                                                                        iconColor:
                                                                            Colors.white,
                                                                        backgroundColor:
                                                                            ApplicationColours.themeLightPinkColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      // News content
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // post image
                                                          //Media Carausel
                                                          NetworkMediaCarouselWidget(
                                                            dotHeight: 8,
                                                            dotWidth: 8,
                                                            media: newsPostModel
                                                                .media,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 5,
                                                              horizontal: 8,
                                                            ),
                                                            child:
                                                                NewsCategoryTimeWidget(
                                                              category:
                                                                  newsPostModel
                                                                      .category
                                                                      .name,
                                                              createdAt:
                                                                  newsPostModel
                                                                      .createdAt,
                                                            ),
                                                          ),
                                                          // location
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  SVGAssetsImages
                                                                      .newsLocation,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  newsPostModel
                                                                      .postLocation
                                                                      .address,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            35,
                                                                            32,
                                                                            31,
                                                                            1),
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // captions
                                                                // ReadMoreText(
                                                                //   newsPostModel
                                                                //       .description,
                                                                //   readMoreText:
                                                                //       tr(LocaleKeys.readMore),
                                                                //   readLessText:
                                                                //       tr(LocaleKeys.readLess),
                                                                //   style:
                                                                //       const TextStyle(
                                                                //     color: Color.fromRGBO(
                                                                //         109,
                                                                //         109,
                                                                //         109,
                                                                //         1),
                                                                //     fontSize:
                                                                //         13,
                                                                //     fontWeight:
                                                                //         FontWeight.w400,
                                                                //   ),
                                                                // ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8),
                                                                  child:
                                                                      GoogleTranslateText(
                                                                    text: newsPostModel
                                                                        .description,
                                                                    targetLanguageCode: newsLanguageChangeControllerState
                                                                        .selectedLanguage
                                                                        .languageEnum
                                                                        .locale
                                                                        .languageCode,
                                                                    enableTranslation:
                                                                        newsLanguageChangeControllerState
                                                                            .enableTranslation,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          109,
                                                                          109,
                                                                          109,
                                                                          1),
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    215,
                                                                    244,
                                                                    254,
                                                                    1),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        7,
                                                                    vertical:
                                                                        3),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      SVGAssetsImages
                                                                          .writtenBy,
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                      "${tr(LocaleKeys.writtenBy)} ~ ${newsPostModel.newsReporter.name}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: ApplicationColours
                                                                            .themeBlueColor,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        thickness: 4,
                                                        color: Color.fromRGBO(
                                                            239, 239, 239, 1),
                                                      ),
                                                      NewsPostChannelProfileWidget(
                                                        newsPostModel:
                                                            newsPostModel,
                                                      ),
                                                      // like share comment
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            PostViewBottomWidget(
                                                          verticalPostView:
                                                              true,
                                                          allowComment:
                                                              newsPostModel
                                                                  .postCommentPermission
                                                                  .allowComment,
                                                          allowShare: newsPostModel
                                                              .postSharePermission
                                                              .allowShare,
                                                          postId:
                                                              newsPostModel.id,
                                                          shareCount:
                                                              newsPostModel
                                                                  .shareCount,
                                                          commentCount:
                                                              newsPostModel
                                                                  .commentCount,
                                                          reactionEmojiModel:
                                                              newsPostModel
                                                                  .reactionEmojiModel,
                                                          postFrom:
                                                              newsPostModel
                                                                  .postFrom,
                                                          postType:
                                                              newsPostModel
                                                                  .postType,
                                                          postReactionDetails:
                                                              newsPostModel
                                                                  .postReactionDetailsModel,
                                                          onCommentTap: () {
                                                            context
                                                                .read<
                                                                    CommentViewControllerCubit>()
                                                                .enableCommentView();
                                                          },
                                                          onReact: (reactionEmoji,
                                                              removeReaction) async {
                                                            onReact(
                                                              reactionEmoji:
                                                                  reactionEmoji,
                                                              isFirstReaction:
                                                                  newsPostModel
                                                                          .reactionEmojiModel ==
                                                                      null,
                                                              postId:
                                                                  newsPostModel
                                                                      .id,
                                                              removeReaction:
                                                                  removeReaction,
                                                              postDetailsControllerCubit:
                                                                  context.read<
                                                                      PostDetailsControllerCubit>(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Reaction box
                                                BlocBuilder<ShowReactionCubit,
                                                    ShowReactionState>(
                                                  builder: (context,
                                                      showReactionState) {
                                                    return Visibility(
                                                      visible: showReactionState
                                                              .showEmojiOption &&
                                                          showReactionState
                                                                  .objectId ==
                                                              newsPostModel.id,
                                                      child: Positioned(
                                                        bottom: mqSize.height *
                                                            0.02,
                                                        right: 0,
                                                        left: 0,
                                                        child: ReactionWidget(
                                                          postId:
                                                              newsPostModel.id,
                                                          onReact:
                                                              (reaction) async {
                                                            onReact(
                                                              reactionEmoji:
                                                                  reaction,
                                                              isFirstReaction:
                                                                  newsPostModel
                                                                          .reactionEmojiModel ==
                                                                      null,
                                                              postId:
                                                                  newsPostModel
                                                                      .id,
                                                              postDetailsControllerCubit:
                                                                  context.read<
                                                                      PostDetailsControllerCubit>(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (commentViewControllerState
                                                .enableComment)
                                              Container(
                                                color: Colors.white,
                                                child: CommentBuilder(
                                                  scrollController:
                                                      postViewScrollController,
                                                  postId: newsPostModel.id,
                                                  postFrom:
                                                      newsPostModel.postFrom,
                                                  postType:
                                                      newsPostModel.postType,
                                                  commentController:
                                                      commentController,
                                                  commentFocusNode:
                                                      commentFocusNode,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (commentViewControllerState
                                          .enableComment)
                                        BlocBuilder<
                                            CommentReplyStatusControllerCubit,
                                            CommentReplyStatusControllerState>(
                                          builder: (context,
                                              commentReplyStatusControllerState) {
                                            final replyUserName =
                                                commentReplyStatusControllerState
                                                    .userName;
                                            final String hint =
                                                commentReplyStatusControllerState
                                                        .isReply
                                                    ? "${tr(LocaleKeys.replyTo)} $replyUserName"
                                                    : "${tr(LocaleKeys.commentAs)} $replyUserName";
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      commentReplyStatusControllerState
                                                          .isReply,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // disbale reply mode
                                                        context
                                                            .read<
                                                                CommentReplyStatusControllerCubit>()
                                                            .toggleReply(
                                                                isReply: false);
                                                      },
                                                      child: Text(
                                                        tr(LocaleKeys
                                                            .cancelReply),
                                                        style: TextStyle(
                                                          color: ApplicationColours
                                                              .themeLightPinkColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                BlocBuilder<CommentActionsCubit,
                                                    CommentActionsState>(
                                                  builder: (context,
                                                      commentActionsState) {
                                                    return SendCommentWidget(
                                                      hint: hint,
                                                      enable:
                                                          !commentActionsState
                                                              .requestLoading,
                                                      textController:
                                                          commentController,
                                                      focusNode:
                                                          commentFocusNode,
                                                      onCommentSend:
                                                          (message) async {
                                                        // //Scroll to start
                                                        // scrollToStart(postViewScrollController);
                                                        context
                                                            .read<
                                                                SendCommentCubit>()
                                                            .onComment(message);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                    ]);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                //News post details loading
                return const ThemeSpinner();
              }
            },
          ),
        ),
      ),
    );
  }
}
