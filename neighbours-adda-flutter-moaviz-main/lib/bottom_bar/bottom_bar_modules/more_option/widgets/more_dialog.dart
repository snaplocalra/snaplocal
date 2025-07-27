import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/screens/business_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/screens/buy_sell_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/screen/category_wise_feed_posts_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/screens/event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/screens/jobs_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/screen/polls_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../groups/models/group_list_type.dart';

class MoreDialogWidget extends StatefulWidget {
  const MoreDialogWidget({super.key});

  @override
  State<MoreDialogWidget> createState() => _MoreDialogWidgetState();
}

class _MoreDialogWidgetState extends State<MoreDialogWidget> {
  List<MoreMenuWidget> get menuList => [
        MoreMenuWidget(
          //name: tr(LocaleKeys.groups),
          name: "Local Groups",
          svgImagePath: SVGAssetsImages.groupsColored,
          onTap: () {
            GoRouter.of(context).pushNamed(
              GroupScreen.routeName,
              extra: GroupListType.groupsYouJoined,
            );
          },
        ),
        MoreMenuWidget(
          //name: tr(LocaleKeys.pages),
          name: "Local Pages",
          svgImagePath: SVGAssetsImages.pages,
          onTap: () {
            GoRouter.of(context).pushNamed(
              PageScreen.routeName,
              extra: PageListType.pagesYouFollow,
            );
          },
        ),
        MoreMenuWidget(
          name: tr(LocaleKeys.safetyAndAlerts),
          svgImagePath: SVGAssetsImages.safety,
          onTap: () {
            GoRouter.of(context).pushNamed(
              CategoryWiseFeedPostsScreen.routeName,
              extra: FeedPostCategoryType.safety,
            );
          },
        ),
        MoreMenuWidget(
          name: tr(LocaleKeys.lostAndFound),
          svgImagePath: SVGAssetsImages.lostFound,
          onTap: () {
            GoRouter.of(context).pushNamed(
              CategoryWiseFeedPostsScreen.routeName,
              extra: FeedPostCategoryType.lostFound,
            );
          },
        ),
        MoreMenuWidget(
          //name: tr(LocaleKeys.event),
          name: "Local Events",
          svgImagePath: SVGAssetsImages.event,
          onTap: () {
            GoRouter.of(context).pushNamed(
              EventScreen.routeName,
              extra: EventPostListType.localEvents,
            );
          },
        ),
        MoreMenuWidget(
          name: tr(LocaleKeys.polls),
          svgImagePath: SVGAssetsImages.polls,
          onTap: () {
            GoRouter.of(context).pushNamed(
              PollsScreen.routeName,
              extra: PollsListType.onGoing,
            );
          },
        ),
        MoreMenuWidget(
          //name: tr(LocaleKeys.jobs),
          name: "Local Jobs",
          svgImagePath: SVGAssetsImages.jobs,
          onTap: () {
            GoRouter.of(context).pushNamed(
              JobsScreen.routeName,
              extra: JobsListType.byNeighbours,
            );
          },
        ),

        MoreMenuWidget(
          //name: tr(LocaleKeys.buyAndsell),
          name: "Local Buy & Sell",
          svgImagePath: SVGAssetsImages.buySellMore,
          onTap: () {
            GoRouter.of(context).pushNamed(
              BuySellScreen.routeName,
              extra: SalesPostListType.marketLocally,
            );
          },
        ),
        MoreMenuWidget(
          //name: tr(LocaleKeys.offer),
          name: "Local Offers",
          svgImagePath: SVGAssetsImages.offersAndCoupons,
          onTap: () {
            GoRouter.of(context).pushNamed(
              BusinessScreen.routeName,
              extra: BusinessViewType.offers,
            );
          },
        ),
        // commited as per the client requirement
        // MoreMenuWidget(
        //   name: tr(LocaleKeys.hallOfFame),
        //   svgImagePath: SVGAssetsImages.hallOfGame,
        //   onTap: () {
        //     GoRouter.of(context).pushNamed(HallOfFameScreen.routeName);
        //   },
        // ),
      ];

  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //       child: Container(
    //         color:
    //             Colors.black.withOpacity(0.5), // Adjust the opacity as needed
    //       ),
    //     ),
    //     Dialog(
    //       child: ListView(
    //         shrinkWrap: true,
    //         children: [
    //           GridView.builder(
    //             physics: const NeverScrollableScrollPhysics(),
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    //             shrinkWrap: true,
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisSpacing: 10,
    //               mainAxisSpacing: 10,
    //               crossAxisCount: 3,
    //               childAspectRatio: 0.85,
    //             ),
    //             itemCount: menuList.length,
    //             itemBuilder: (context, index) {
    //               final menu = menuList[index];
    //               return menu;
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
    return Dialog(
      elevation: 0,
      child: ListView(
        shrinkWrap: true,
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              childAspectRatio: 0.85,
            ),
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              final menu = menuList[index];
              return menu;
            },
          ),
        ],
      ),
    );
  }
}

class MoreMenuWidget extends StatelessWidget {
  final String name;
  final String svgImagePath;
  final void Function() onTap;
  final bool disableAutoPop;
  final Color? cardColor;
  final Color? svgCircleColor;

  const MoreMenuWidget({
    super.key,
    required this.name,
    required this.svgImagePath,
    required this.onTap,
    this.disableAutoPop = false,
    this.cardColor,
    this.svgCircleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
        if (disableAutoPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cardColor ?? const Color.fromRGBO(239, 239, 239, 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1,
              spreadRadius: 0,
              // Offset controls the position of the shadow
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: svgCircleColor ?? Colors.white,
                child: SvgPicture.asset(
                  svgImagePath,
                  height: 30,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                tr(name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
