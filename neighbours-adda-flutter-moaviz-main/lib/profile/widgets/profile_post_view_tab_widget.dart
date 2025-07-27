import 'package:flutter/material.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ProfilePostViewTabWidget extends StatefulWidget {
  final Widget Function(TabController tabController) tabViewBuilder;
  final void Function(PostViewType postType) onTabChange;
  const ProfilePostViewTabWidget({
    super.key,
    required this.tabViewBuilder,
    required this.onTabChange,
  });

  @override
  State<ProfilePostViewTabWidget> createState() =>
      _ProfilePostsViewTabWidgetState();
}

class _ProfilePostsViewTabWidgetState extends State<ProfilePostViewTabWidget>
    with TickerProviderStateMixin {
  late TabController tabController = TabController(
    length: PostViewTypeList().data.length,
    vsync: this,
  );

  @override
  initState() {
    super.initState();

    //listen to tab change
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        //This will implemented to check whether the user changing the tab by tapping or not.
        //If the user change the tab by tapping then avoid the api calling.Because after tap,when the index will
        //change then the api will call to fetch data.
        // return;
        return;
      } else {
        widget.onTabChange(PostViewTypeList().data[tabController.index]);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Tab bar menu
        Container(
          color: const Color.fromARGB(31, 167, 164, 164),
          child: TabBar(
            controller: tabController,
            labelColor: ApplicationColours.themeLightPinkColor,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ApplicationColours.themeLightPinkColor,
            ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              //Add the border to the indicator except the bottom side
              border: Border(
                top: BorderSide(
                  color: ApplicationColours.themeLightPinkColor,
                  width: 1,
                ),
                left: BorderSide(
                  color: ApplicationColours.themeLightPinkColor,
                  width: 1,
                ),
                right: BorderSide(
                  color: ApplicationColours.themeLightPinkColor,
                  width: 1,
                ),
              ),
            ),
            unselectedLabelColor: ApplicationColours.unselectedLabelColor,
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              ...List<Widget>.generate(
                PostViewTypeList().data.length,
                (index) => Tab(
                  height: 40,
                  child: Text(
                    PostViewTypeList().data[index].displayText,
                  ),
                ),
              ),
            ],
          ),
        ),

        //Tab bar view
        widget.tabViewBuilder(tabController),
      ],
    );
  }
}
