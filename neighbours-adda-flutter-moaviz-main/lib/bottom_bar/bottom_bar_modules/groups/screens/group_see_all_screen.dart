// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/screen/create_or_update_group_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/search_group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_seeall_screen_data_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/common/utils/widgets/search_with_filter_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class GroupSeeAllScreen extends StatefulWidget {
  const GroupSeeAllScreen({super.key});
  static const routeName = 'group_see_all';

  @override
  State<GroupSeeAllScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupSeeAllScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  GlobalKey groupSearchIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    //Fetch both type groups data
    context.read<GroupListCubit>().fetchGroups();
  }

  void openCreateOrUpdateGroupDetailsScreen(
      ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.socialMediaLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(CreateOrUpdateGroupDetailsScreen.routeName)
              .whenComplete(() => context.read<GroupListCubit>().fetchGroups(
                  groupListType: GroupListType.managedByYou,
                  disableLoading: true));
        }
      } else {
        showThemeAlertDialog(
          context: context,
          onAcceptPressed: () {
            if (mounted) {
              GoRouter.of(context).pushNamed(
                LocationManageMapScreen.routeName,
                extra: {
                  "locationType": LocationType.socialMedia,
                  "locationManageType": LocationManageType.setting,
                },
              );
            }
          },
          agreeButtonText: "Update Now",
          cancelButtonText: tr(LocaleKeys.cancel),
          title: "You need to update your location to procced.",
        );
      }
    }
  }

  void willPopScope() {
    GoRouter.of(context).pop();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        willPopScope();
      },
      child: Scaffold(
        appBar: ThemeAppBar(
          appBarHeight: 60,
          backgroundColor: Colors.white,
          title: Text(
            tr(LocaleKeys.groups),
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: PageHeading(
                svgPath: SVGAssetsImages.groupsColored,
                heading: GroupListType.managedByYou.name,
                subHeading: GroupListType.managedByYou.description,
              ),
            ),
            SearchBoxWidget(
              key: groupSearchIconKey,
              searchHint: tr(LocaleKeys.searchGroup),
              onSearchTap: () {
                GoRouter.of(context).pushNamed(SearchGroupScreen.routeName);
              },
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 5),
              child: AddressWithLocateMe(
                key: _addressWithLocateMeKey,
                is3D: true,
                iconSize: 15,
                iconTopPadding: 0,
                locationType: LocationType.socialMedia,
                contentMargin: EdgeInsets.zero,
                height: 35,
                decoration: BoxDecoration(
                  color: ApplicationColours.skyColor.withOpacity(1),
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: null,
              ),
            ),
            Expanded(
              child: BlocBuilder<GroupListCubit, GroupListState>(
                builder: (context, groupListState) {
                  final groupListModel = groupListState.groupTypeListModel;

                  final managedByYouData = groupListModel.managedByYou.data;

                  final joinedGroupsData = groupListModel.groupsYouJoined.data;

                  final showLoading =
                      groupListState.isManagedByYouDataLoading &&
                          groupListState.isGroupYouJoinedDataLoading;

                  if (showLoading) {
                    return Container(
                      color: Colors.white,
                      child: const CircleCardShimmerListBuilder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                    );
                  } else {
                    return RefreshIndicator.adaptive(
                      onRefresh: () async {
                        context.read<GroupListCubit>().fetchGroups();
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          //if both groups are empty
                          if (managedByYouData.isEmpty &&
                              joinedGroupsData.isEmpty)
                            Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: const EmptyDataPlaceHolder(
                                emptyDataType: EmptyDataType.group,
                              ),
                            ),

                          //Admin groups
                          if (managedByYouData.isNotEmpty)
                            GroupSeeAllScreenDataWidget(
                              groupList: managedByYouData,
                              header: 'Admin',
                              onLoadMore: () {
                                context.read<GroupListCubit>().fetchGroups(
                                      loadMoreData: true,
                                      groupListType: GroupListType.managedByYou,
                                    );
                              },
                              isLastPage: groupListModel
                                  .managedByYou.paginationModel.isLastPage,
                            ),

                          //Joined groups
                          if (joinedGroupsData.isNotEmpty)
                            GroupSeeAllScreenDataWidget(
                              groupList: joinedGroupsData,
                              header: 'Member',
                              onLoadMore: () {
                                context.read<GroupListCubit>().fetchGroups(
                                      loadMoreData: true,
                                      groupListType:
                                          GroupListType.groupsYouJoined,
                                    );
                              },
                              isLastPage: groupListModel
                                  .groupsYouJoined.paginationModel.isLastPage,
                            ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton:
            BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
          builder: (context, profileSettingsState) {
            if (profileSettingsState.isProfileSettingModelAvailable) {
              return ManagePostActionButton(
                onPressed: () {
                  openCreateOrUpdateGroupDetailsScreen(profileSettingsState);
                },
                text: tr(LocaleKeys.createGroup),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
