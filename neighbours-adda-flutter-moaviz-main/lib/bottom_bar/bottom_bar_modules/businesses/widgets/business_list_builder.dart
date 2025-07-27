import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_list/business_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/short_business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/business_short_details_widget.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_visibility/bottom_bar_visibility_cubit.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/rectangle_list_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';

class BusinessListBuilder extends StatelessWidget {
  final BusinessViewType businessViewType;
  final void Function()? onPagination;
  final Future<void> Function() onRefresh;

  const BusinessListBuilder({
    super.key,
    required this.businessViewType,
    this.onPagination,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessListCubit, BusinessListState>(
      builder: (context, businessListState) {
        final profileSettingsModel =
            context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

        final LatLng? marketPlaceLocation =
            profileSettingsModel.marketPlaceLocation == null
                ? null
                : LatLng(
                    profileSettingsModel.marketPlaceLocation!.latitude,
                    profileSettingsModel.marketPlaceLocation!.longitude,
                  );

        final marketPlaceCoveredAreaRadius =
            profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius;

        final logs = businessListState.businessListModel;
        if (businessListState.error != null) {
          return ErrorTextWidget(error: businessListState.error!);
        } else if (businessListState.dataLoading) {
          return const ReactangleListShimmerBuilder();
        } else if (businessListState.businessListModel == null) {
          return const SizedBox.shrink();
        } else {
          return logs!.data.isEmpty
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const EmptyDataPlaceHolder(
                    emptyDataType: EmptyDataType.business,
                    backgroundcolor: Colors.transparent,
                  ),
                )
              : DataListWithMapViewWidget(
                  customMarker: PNGAssetsImages.businessMapMarker,
                  initialLocation: marketPlaceLocation,
                  coveredAreaRadius: marketPlaceCoveredAreaRadius,
                  clusterMarkerList: logs.data
                      .map(
                        (e) => ClusterMarkerModel(
                          id: e.id,
                          latlng: LatLng(
                            e.postLocation.latitude,
                            e.postLocation.longitude,
                          ),
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
                          builder: (context, searchQuery) => BusinessListView(
                            logs: selectedMarkers
                                .map((e) => logs.data.firstWhere(
                                    (element) => element.id == e.id))

                                //search filter
                                .where((element) =>
                                    element.searchKeyword(searchQuery))
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  onListType: BusinessListView(
                    logs: logs.data,
                    isLastPage: logs.paginationModel.isLastPage,
                    onPagination: onPagination,
                  ),
                  onRefresh: onRefresh,
                );
        }
      },
    );
  }
}

class BusinessListView extends StatefulWidget {
  final List<ShortBusinessDetailsModel> logs;
  final bool isLastPage;
  final void Function()? onPagination;

  const BusinessListView({
    super.key,
    required this.logs,
    this.isLastPage = true,
    this.onPagination,
  });

  @override
  State<BusinessListView> createState() => _BusinessListViewState();
}

class _BusinessListViewState extends State<BusinessListView> {
  final businessListScrollController = ScrollController();
  //use for bottom bar hide
  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  @override
  void initState() {
    super.initState();

    //////
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessListScrollController.addListener(() {
        businessListScrollController.position.isScrollingNotifier
            .addListener(() {
          //////
          if (businessListScrollController.position.maxScrollExtent ==
              businessListScrollController.offset) {
            widget.onPagination?.call();
          }

          //Find the scrolling speed
          final currentScrollOffset =
              businessListScrollController.position.pixels;
          final currentTime = DateTime.now();
          if (previousEventTime != null) {
            final scrollDistance =
                (currentScrollOffset - previousScrollOffset).abs();
            final timeDifference =
                currentTime.difference(previousEventTime!).inMicroseconds;

            final scrollSpeed = scrollDistance / timeDifference;

            //As per the scrolling speed and scroll direction show and hide the buttom bar
            if (businessListScrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
              context.read<BottomBarVisibilityCubit>().hideBottomBar();
            } else if (scrollSpeed < 1 &&
                businessListScrollController.position.userScrollDirection ==
                    ScrollDirection.forward) {
              context.read<BottomBarVisibilityCubit>().showBottomBar();
            }
          }
          previousEventTime = currentTime;
          previousScrollOffset = currentScrollOffset;
        });
      });
    });
  }

  @override
  void dispose() {
    businessListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomBarNavigatorCubit, BottomBarNavigatorState>(
      listener: (context, bottomBarNavigationState) async {
        if (bottomBarNavigationState.currentSelectedScreenIndex == 3) {
          await scrollToStart(businessListScrollController);
        }
      },
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: businessListScrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: widget.logs.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.logs.length) {
            final business = widget.logs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 120,
                child: BusinessShortDetailsWidget(
                  businessId: business.id,
                  businessName: business.businessName,
                  businessCategory: business.category.subCategoryString(),
                  businessAddress: business.postLocation.address,
                  distance: business.distance,
                  businessMedia: business.media.first,
                  ratings: business.ratingsModel.starRating,
                  unbeatableDeal: business.isUnbeatableDeal,
                ),
              ),
            );
          } else {
            return Visibility(
              visible: !widget.isLastPage,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: ThemeSpinner(size: 40),
              ),
            );
          }
        },
      ),
    );
  }
}
