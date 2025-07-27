import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_home_data/group_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_list_tile_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_v2_grid_data_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

import '../screens/group_see_all_screen.dart';
import 'see_all_screen.dart';

class GroupListWidgetV2 extends StatelessWidget {
  final GroupListType groupListType;
  final ScrollController? controller;
  const GroupListWidgetV2({
    super.key,
    required this.groupListType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupHomeDataCubit, GroupHomeDataState>(
      builder: (context, groupHomeDataState) {
        if (groupHomeDataState is GroupHomeDataError) {
          return ErrorTextWidget(error: groupHomeDataState.error);
        } else if (groupHomeDataState is GroupHomeDataLoaded) {
          final logs = groupHomeDataState.data;
          final profileSettingsModel =
              context.read<ProfileSettingsCubit>().state.profileSettingsModel!;
          final socialMediaSearchRadius =
              profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;
          final socialMediaLocation = profileSettingsModel.socialMediaLocation;
          return logs.isEmpty
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const EmptyDataPlaceHolder(
                    emptyDataType: EmptyDataType.group,
                  ),
                )
              : DataListWithMapViewWidget(
                  controller: controller,
                  onRefresh: () => context
                      .read<GroupListCubit>()
                      .fetchGroups(groupListType: groupListType),
                  customMarker: PNGAssetsImages.groupMapMarker,
                  initialLocation: socialMediaLocation!.toLatLng(),
                  coveredAreaRadius: socialMediaSearchRadius,
                  clusterMarkerList: logs
                      .map(
                        (e) => ClusterMarkerModel(
                          id: e.groupId,
                          latlng: e.location.toLatLng(),
                        ),
                      )
                      .toList(),
                  onClustersTap: (selectedMarkers) {
                    //show a bottom sheet with the list of neighbours in horizontal
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (context) {
                        return MapViewDataListBottomSheet(
                            markersCount: selectedMarkers.length,
                            builder: (context, searchQuery) {
                              //filter the list of markers based on the search query
                              final filteredMarkers = selectedMarkers
                                  .map((e) => logs.firstWhere(
                                      (element) => element.groupId == e.id))

                                  //search filter
                                  .where((element) =>
                                      element.searchKeyword(searchQuery))
                                  .toList();
                              return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                controller: controller,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredMarkers.length,
                                itemBuilder: (BuildContext context, index) {
                                  final groupDetails = filteredMarkers[index];
                                  return GroupListTileWidget(
                                    key: ValueKey(groupDetails.groupId),
                                    groupName: groupDetails.groupName,
                                    groupDescription:
                                        groupDetails.groupDescription,
                                    groupId: groupDetails.groupId,
                                    groupImageUrl: groupDetails.groupImage,
                                    unSeenPostCount:
                                        groupDetails.unseenPostCount,
                                    isJoined: groupDetails.isJoined,
                                    isGroupAdmin: groupDetails.isGroupAdmin,
                                    isVerified: groupDetails.isVerified,
                                    onGroupJoinExit: (isJoined) {
                                      //update the join status of the group
                                      groupDetails.isJoined = isJoined;

                                      //refresh the group list
                                      context
                                          .read<GroupListCubit>()
                                          .refreshState();
                                    },
                                  );
                                },
                              );
                            });
                      },
                    );
                  },
                  onListType: Column(
                    children: [
                      //See all
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              // print("Hello  ${filter.type}");
                              // Navigate to the see all screen
                              // GoRouter.of(context)
                              //     .pushNamed(GroupSeeAllScreen.routeName);
                              print('Group List Type: ${groupListType}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeeAllAscreen(
                                      groupListType: groupListType,
                                      // isFromMapView: true,
                                    ),
                                  ));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: ApplicationColours.themePinkColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    ApplicationColours.themePinkColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: 160,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: logs.length,
                          itemBuilder: (BuildContext context, index) {
                            final groupDetails = logs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: MapV2GridDataWidget(
                                isVerified: groupDetails.isVerified,
                                imageUrl: groupDetails.groupImage,
                                title: groupDetails.groupName,
                                subTitle: groupDetails.groupMemberCount > 0
                                    ? "${groupDetails.groupMemberCount.formatNumber()} ${groupDetails.groupMemberCount > 1 ? 'Members' : 'Member'}"
                                    : null,
                                unseenPostCount: groupDetails.unseenPostCount,
                                onTap: () {
                                  //navigate to the group details screen
                                  GoRouter.of(context).pushNamed(
                                    GroupDetailsScreen.routeName,
                                    queryParameters: {
                                      'id': groupDetails.groupId
                                    },
                                    extra: index,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        } else {
          return Container(
            color: Colors.white,
            child: const CircleCardShimmerListBuilder(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
          );
        }
      },
    );
  }
}
