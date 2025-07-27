import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/model/news_channel_overview_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/widget/news_channel_statistics_data.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsChannelStatisticsWidget extends StatelessWidget {
  final NewsChannelOverviewStatisticsModel newsChannelOverviewStatistics;
  const NewsChannelStatisticsWidget({
    super.key,
    required this.newsChannelOverviewStatistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              NewsStatisticsDataWidget(
                title: tr(LocaleKeys.totalNewsPosted),
                value: newsChannelOverviewStatistics.totalNewsPosted,
              ),
              NewsStatisticsDataWidget(
                title: tr(LocaleKeys.totalLikes),
                value: newsChannelOverviewStatistics.totalLikes,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              NewsStatisticsDataWidget(
                title: tr(LocaleKeys.totalViews),
                value: newsChannelOverviewStatistics.totalViews,
              ),
              NewsStatisticsDataWidget(
                title: tr(LocaleKeys.totalShares),
                value: newsChannelOverviewStatistics.totalShares,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
