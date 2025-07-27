import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_groups_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_pages_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/buy_sell_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_connections_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_events_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_jobs_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_news_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_videos_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/offers_section.dart';

class HomeScreenNew extends StatelessWidget {
  const HomeScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Static Local Layouts - Construction', style: TextStyle(fontSize: 14),),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalGroupsSection(),
            SizedBox(height: 10),
            LocalNewsSection(),
            SizedBox(height: 10),
            LocalJobsSection(),
            LocalEventsSection(),
            LocalPagesSection(),
            OffersNearYouSection(),
            BuyAndSellSection(),
            LocalVideosSection(),
            ConnectionsSection(),
          ],
        ),
      ),
    );
  }
} 