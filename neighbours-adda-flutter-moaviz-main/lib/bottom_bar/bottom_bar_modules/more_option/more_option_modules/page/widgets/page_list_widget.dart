import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_home_data/page_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_seeall_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_tile_widget.dart';
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

import '../screens/page_see_all_screen.dart';

class PageListWidget extends StatelessWidget {
  final PageListType pageListType;
  final ScrollController? controller;
  const PageListWidget({
    super.key,
    required this.pageListType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageHomeDataCubit, PageHomeDataState>(
      builder: (context, pageHomeDataState) {
        if (pageHomeDataState is PageHomeDataError) {
          return ErrorTextWidget(error: pageHomeDataState.error);
        } else if (pageHomeDataState is PageHomeDataLoaded) {
          final logs = pageHomeDataState.data;

          final profileSettingsModel =
              context.read<ProfileSettingsCubit>().state.profileSettingsModel!;
          final socialMediaSearchRadius =
              profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;
          final socialMediaLocation = profileSettingsModel.socialMediaLocation;

          return (logs.isEmpty)
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const EmptyDataPlaceHolder(
                    emptyDataType: EmptyDataType.page,
                  ),
                )
              : DataListWithMapViewWidget(
                  controller: controller,
                  onRefresh: () => context
                      .read<PageListCubit>()
                      .fetchPages(pageListType: pageListType),
                  customMarker: PNGAssetsImages.pageMapMarker,
                  initialLocation: socialMediaLocation!.toLatLng(),
                  coveredAreaRadius: socialMediaSearchRadius,
                  clusterMarkerList: logs
                      .map(
                        (e) => ClusterMarkerModel(
                          id: e.pageId,
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
                                      (element) => element.pageId == e.id))

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
                                  final pageDetails = filteredMarkers[index];
                                  return PageListTileWidget(
                                    key: ValueKey(pageDetails.pageId),
                                    pageName: pageDetails.pageName,
                                    isVerified: pageDetails.isVerified,
                                    pageDescription:
                                        pageDetails.pageDescription,
                                    pageId: pageDetails.pageId,
                                    pageImageUrl: pageDetails.pageImage,
                                    isFollowing: pageDetails.isFollowing,
                                    isPageAdmin: pageDetails.isPageAdmin,
                                    isBlockByUser: pageDetails.blockedByUser,
                                    isBlockByAdmin: pageDetails.blockedByAdmin,
                                    unSeenPostCount:
                                        pageDetails.unseenPostCount,
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
                              // GoRouter.of(context)
                              //     .pushNamed(PageSeeAllScreen.routeName);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeeAllAscreenPages(
                                        // groupListType: groupListType,
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
                            final pageDetails = logs[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: MapV2GridDataWidget(
                                imageUrl: pageDetails.pageImage,
                                title: pageDetails.pageName,
                                isVerified: pageDetails.isVerified,
                                subTitle: pageDetails.pageMemberCount > 0
                                    ? "${pageDetails.pageMemberCount.formatNumber()} ${pageDetails.pageMemberCount > 1 ? 'Followers' : 'Follower'}"
                                    : null,
                                unseenPostCount: pageDetails.unseenPostCount,
                                onTap: () {
                                  //navigate to the group details screen
                                  GoRouter.of(context).pushNamed(
                                    PageDetailsScreen.routeName,
                                    queryParameters: {'id': pageDetails.pageId},
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
