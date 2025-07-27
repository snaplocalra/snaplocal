import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_news_list/news_dashboard_news_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_statistics/news_dashboard_statistics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/time_frame_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/logic/news_earnings/news_earnings_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/widgets/news_earnings.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/widget/dashboard_own_news_channel_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/widget/dashboard_statistics_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class MyDashboardScreen extends StatefulWidget {
  static const routeName = 'my_dashboard_views';

  const MyDashboardScreen({super.key});

  @override
  State<MyDashboardScreen> createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen> {
  final newsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (context.read<OwnNewsChannelCubit>().state is OwnNewsChannelLoaded) {
      final ownNewsChannel =
          (context.read<OwnNewsChannelCubit>().state as OwnNewsChannelLoaded)
              .ownNewsChannel;

      if (ownNewsChannel != null) {
        //Fetch dashboard statistics
        context
            .read<NewsDashboardStatisticsCubit>()
            .fetchNewsDashboardStatistics(
              channelId: ownNewsChannel.id!,
              timeFrame: TimeFrameEnum.twentyFourHours,
            );

        //Fetch earnings details
        context
            .read<NewsEarningsCubit>()
            .fetchNewsEarningsDetails(ownNewsChannel.id!);

        //Fetch top performing news and my approved news
        context.read<NewsDashboardNewsListCubit>().fetchNewsDashboardNewsList();
      }
    }
  }

  @override
  void dispose() {
    newsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        backgroundColor: Colors.white,
        showBackButton: true,
        appBarHeight: 50,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Text(
                tr(LocaleKeys.myDashboard),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<OwnNewsChannelCubit, OwnNewsChannelState>(
        builder: (context, ownNewsChannelState) {
          if (ownNewsChannelState is OwnNewsChannelLoadFailed) {
            return ErrorTextWidget(
              error: ownNewsChannelState.errorMessage,
            );
          } else if (ownNewsChannelState is OwnNewsChannelLoaded) {
            final newsChannelInfo = ownNewsChannelState.ownNewsChannel;
            return (newsChannelInfo != null)
                ? ListView(
                    padding: const EdgeInsets.all(8),
                    controller: newsScrollController,
                    children: [
                      //News Channel Details
                      DashboardOwnNewsChannelDetails(
                        newsChannelInfo: newsChannelInfo,
                      ),

                      //News Dashboard
                      DashboardStatisticsWidget(
                        channelId: newsChannelInfo.id!,
                      ),

                      //News Earnings
                      NewsEarnings(channelId: newsChannelInfo.id!),

                      //News List
                      DashboardNewsListWidget(
                        newsScrollController: newsScrollController,
                      ),
                    ],
                  )
                : const SizedBox.shrink();
          }
          return const ThemeSpinner();
        },
      ),
    );
  }
}

class DashboardNewsListWidget extends StatefulWidget {
  final ScrollController newsScrollController;
  const DashboardNewsListWidget({
    super.key,
    required this.newsScrollController,
  });

  @override
  State<DashboardNewsListWidget> createState() =>
      _DashboardNewsListWidgetState();
}

class _DashboardNewsListWidgetState extends State<DashboardNewsListWidget> {
  final topPerformingNewsShowReactionCubit = ShowReactionCubit();
  final myApprovedNewsShowReactionCubit = ShowReactionCubit();

  @override
  void initState() {
    super.initState();
    widget.newsScrollController.addListener(() {
      topPerformingNewsShowReactionCubit.closeReactionEmojiOption();
      myApprovedNewsShowReactionCubit.closeReactionEmojiOption();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDashboardNewsListCubit, NewsDashboardNewsListState>(
      builder: (context, newsDashboardNewsListState) {
        if (newsDashboardNewsListState is NewsDashboardNewsListLoaded) {
          final topPerformingNews = newsDashboardNewsListState
              .newsDashboardNewsListModel.topPerformingNews;
          final myApprovedNews = newsDashboardNewsListState
              .newsDashboardNewsListModel.myApprovedNews;

          return Column(
            children: [
              // Top Performing News
              Padding(
                key: const ValueKey('topPerformingNews'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: BlocProvider.value(
                  value: topPerformingNewsShowReactionCubit,
                  child: DashboardNewsListRenderWidget(
                    title: tr(LocaleKeys.topPerformingNews),
                    newsList: topPerformingNews,
                    onRemoveItemFromList: (index) {
                      context
                          .read<NewsDashboardNewsListCubit>()
                          .removeNewsPostFromTopPerformingNews(index);
                    },
                  ),
                ),
              ),

              // My Approved News
              BlocProvider.value(
                key: const ValueKey('myApprovedNews'),
                value: myApprovedNewsShowReactionCubit,
                child: DashboardNewsListRenderWidget(
                  title: tr(LocaleKeys.myApprovedNews),
                  newsList: myApprovedNews,
                  onRemoveItemFromList: (index) {
                    context
                        .read<NewsDashboardNewsListCubit>()
                        .removeNewsPostFromMyApprovedNews(index);
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class DashboardNewsListRenderWidget extends StatelessWidget {
  const DashboardNewsListRenderWidget({
    super.key,
    required this.newsList,
    required this.title,
    this.onRemoveItemFromList,
  });

  final String title;
  final SocialPostsList newsList;
  final void Function(int)? onRemoveItemFromList;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: newsList.socialPostList.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ApplicationColours.themeBlueColor,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: SocialPostListBuilder(
              hideBottomBarOnScroll: false,
              physics: const NeverScrollableScrollPhysics(),
              socialPostsModel: newsList,
              showBottomDivider: false,
              onRemoveItemFromList: onRemoveItemFromList,
            ),
          ),
        ],
      ),
    );
  }
}
