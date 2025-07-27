import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/logic/block_controller/block_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/logic/follow_controller/follow_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/model/news_channel_follow_handler.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/logic/channel_overview_controller/channel_overview_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/repository/news_channel_overview_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/widget/news_channel_statistics_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/channel_heading_view.dart';
import 'package:snap_local/common/market_places/send_message_to_neighbours.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_news_channel_follow_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/news_channel_communication_post.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ChannelOverViewScreen extends StatefulWidget {
  final String channelId;
  final PostDetailsControllerCubit? postDetailsControllerCubit;
  const ChannelOverViewScreen({
    super.key,
    required this.channelId,
    required this.postDetailsControllerCubit,
  });

  static const routeName = 'news_channel';

  @override
  State<ChannelOverViewScreen> createState() => _ChannelOverViewScreenState();
}

class _ChannelOverViewScreenState extends State<ChannelOverViewScreen> {
  final newsScrollController = ScrollController();
  final showReactionCubit = ShowReactionCubit();

  final blockControllerCubit = BlockControllerCubit();
  final followControllerCubit = FollowControllerCubit();

  @override
  initState() {
    super.initState();

    newsScrollController.addListener(() {
      showReactionCubit.closeReactionEmojiOption();
    });
  }

  @override
  void dispose() {
    newsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: showReactionCubit),
        BlocProvider.value(value: blockControllerCubit),
        BlocProvider.value(value: followControllerCubit),
        BlocProvider(
          create: (context) =>
              ChannelOverviewControllerCubit(NewsChannelOverviewRepository())
                ..getChannelOverviewData(widget.channelId),
        ),
      ],
      child: BlocListener<FollowControllerCubit, FollowControllerState>(
        listener: (context, followControllerState) {
          if (followControllerState is FollowRequestSuccess) {
            context
                .read<ChannelOverviewControllerCubit>()
                .getChannelOverviewData(widget.channelId);
          }
        },
        child: BlocListener<BlockControllerCubit, BlockControllerState>(
          listener: (context, blockControllerStatb) {
            //on block success, refresh the page
            if (blockControllerStatb is BlockControllerSuccess) {
              context
                  .read<ChannelOverviewControllerCubit>()
                  .getChannelOverviewData(widget.channelId);
            }
          },
          child: Scaffold(
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              showBackButton: true,
              appBarHeight: 50,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text(
                      tr(LocaleKeys.channelOverView),
                      style: TextStyle(
                        color: ApplicationColours.themeBlueColor,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    //Follow button
                    BlocBuilder<ChannelOverviewControllerCubit,
                        ChannelOverviewControllerState>(
                      builder: (context, channelOverviewControllerState) {
                        if (channelOverviewControllerState
                            is ChannelOverviewControllerSuccess) {
                          final isFollowing = channelOverviewControllerState
                              .newsChannelOverViewModel
                              .newsChannelInfoModel
                              .isFollowing;

                          return BlocBuilder<FollowControllerCubit,
                              FollowControllerState>(
                            builder: (context, followControllerState) {
                              return ThemeElevatedButton(
                                width: 100,
                                height: 30,
                                padding: EdgeInsets.zero,
                                textFontSize: 12,
                                showLoadingSpinner: followControllerState
                                    is FollowRequestLoading,
                                buttonName: isFollowing
                                    ? tr(LocaleKeys.followed)
                                    : tr(LocaleKeys.follow),
                                foregroundColor:
                                    isFollowing ? Colors.white : Colors.white,
                                // backgroundColor: ApplicationColours.themePinkColor,
                                onPressed: () {
                                  //update the follow state on the post child if available
                                  widget.postDetailsControllerCubit
                                      ?.postStateUpdate(
                                          UpdateNewsChannelFollowState(
                                    isFollowed: !isFollowing,
                                  ));

                                  //API call to follow the channel
                                  context
                                      .read<FollowControllerCubit>()
                                      .followExcecute(
                                        NewsChannelFollowHandler(
                                          channelOverviewControllerState
                                              .newsChannelOverViewModel
                                              .newsChannelInfoModel
                                              .id,
                                        ),
                                      );
                                },
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: BlocBuilder<ChannelOverviewControllerCubit,
                ChannelOverviewControllerState>(
              builder: (context, channelOverviewControllerState) {
                if (channelOverviewControllerState
                    is ChannelOverviewControllerError) {
                  return ErrorTextWidget(
                    error: channelOverviewControllerState.errorMessage,
                  );
                } else if (channelOverviewControllerState
                    is ChannelOverviewControllerSuccess) {
                  final newsChannelInfo = channelOverviewControllerState
                      .newsChannelOverViewModel.newsChannelInfoModel;

                  final newsFromThisContributor = channelOverviewControllerState
                      .newsChannelOverViewModel.newsFromThisContrubutor;

                  return ListView(
                    controller: newsScrollController,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Channel Heading
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ChannelHeadingView(
                              newsChannelInfo: newsChannelInfo,
                            ),
                          ),

                          //Description
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tr(LocaleKeys.description),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      ReadMoreText(
                                        newsChannelInfo.description,
                                        readMoreText: tr(LocaleKeys.readMore),
                                        readLessText: tr(LocaleKeys.readLess),
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(109, 109, 109, 1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Language
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tr(LocaleKeys.language),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      //TODO: Need to change the language
                                      const Text(
                                        "English",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(109, 109, 109, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Statistics
                          NewsChannelStatisticsWidget(
                            newsChannelOverviewStatistics:
                                channelOverviewControllerState
                                    .newsChannelOverViewModel
                                    .newsChannelOverviewStatistics,
                          ),
                          // Sender Details
                          Visibility(
                            visible: !newsChannelInfo.isChannelAdmin &&
                                newsChannelInfo.enableChat,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: SendMessageToNeighbours(
                                scamType: ScamType.news,
                                receiverUserId: newsChannelInfo.userId,
                                otherCommunicationModelImpl:
                                    NewsChannelCommunicationImpl(
                                  id: newsChannelInfo.id,
                                  newsChannelName: newsChannelInfo.name,
                                ),
                              ),
                            ),
                          ),
                          // News from this reporter
                          if (newsFromThisContributor.socialPostList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //From this reporter
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Text(
                                    tr(LocaleKeys.fromThisReporter),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                //News post from this reporter
                                //Use the SocialPostListBuilder
                                SocialPostListBuilder(
                                  hideBottomBarOnScroll: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  socialPostsModel: newsFromThisContributor,
                                  showBottomDivider: false,
                                  enableNewsPostAction: false,
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  );
                } else {
                  return const ThemeSpinner();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
