import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/models/hall_of_fame_tab_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/widgets/contests_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/widgets/winners_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_icon_widget.dart';
import 'package:snap_local/common/utils/local_notification/widgets/notification_bell.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class HallOfFameScreen extends StatefulWidget {
  final bool navigateToWinnerTab;
  const HallOfFameScreen({
    super.key,
    required this.navigateToWinnerTab,
  });

  static const routeName = 'hall_of_fame';

  @override
  State<HallOfFameScreen> createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends State<HallOfFameScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late HallOfFameTabType hallOfFameTabType;

  List<HallOfFameTabType> hallOfFameTabs = [
    HallOfFameTabType.contests,
    HallOfFameTabType.winners,
  ];

  @override
  void initState() {
    super.initState();

    //Select the 1st type by default
    hallOfFameTabType = hallOfFameTabs.first;
    tabController = TabController(length: hallOfFameTabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            //This will implemented to check whether the user changing the tab by tapping or not.
            return;
          } else {
            return;
          }
        });
        if (widget.navigateToWinnerTab) {
          navigateToWinnerTab();
        }
      },
    );
  }

  void navigateToWinnerTab() {
    //Go to winners tab
    tabController.animateTo(1);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: ThemeAppBar(
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.hallOfFame),
          style: TextStyle(color: ApplicationColours.themeBlueColor),
        ),
        actions: const [
          NotificationBell(),
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: ChatIconWidget(),
          ),
        ],
        appBarHeight: 90,
        bottom: Column(
          children: [
            SizedBox(
              height: 35,
              width: mqSize.width,
              child:
                  //This decorated box is used to draw the unselected lable color
                  DecoratedBox(
                //This is responsible for the background of the tabbar, does the magic
                decoration: const BoxDecoration(
                  //This is for background color
                  color: Colors.transparent,
                  //This is for bottom border that is needed
                  border: Border(
                      bottom: BorderSide(
                    color: Color.fromRGBO(175, 173, 173, 0.6),
                    width: 2.5,
                  )),
                ),
                child: TabBar(
                  controller: tabController,
                  labelColor: ApplicationColours.themeBlueColor,
                  indicatorWeight: 2.5,
                  indicatorColor: ApplicationColours.themeBlueColor,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelColor: ApplicationColours.unselectedLabelColor,
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    ...List<Widget>.generate(
                      hallOfFameTabs.length,
                      (index) => Tab(
                        child: Text(tr(hallOfFameTabs[index].name)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ContestsWidget(
            onWinnerBannerTap: () {
              //Go to winners tab
              navigateToWinnerTab();
            },
          ),
          const WinnersWidget(),
        ],
      ),
    );
  }
}
