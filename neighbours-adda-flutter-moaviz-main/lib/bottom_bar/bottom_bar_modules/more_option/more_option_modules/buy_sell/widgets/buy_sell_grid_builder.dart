import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/logic/sales_post/sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/sales_post_short_details_grid_widget.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/widgets/shimmers/square_grid_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';

class BuySellGridBuilder extends StatelessWidget {
  final SalesPostListType salesPostListType;
  final bool isOwnPost;
  final void Function()? onPagination;
  final void Function()? reFreshParentData;

  const BuySellGridBuilder({
    super.key,
    required this.salesPostListType,
    this.isOwnPost = false,
    this.onPagination,
    this.reFreshParentData,
  });

  @override
  Widget build(BuildContext context) {
    return //Sales post data
        BlocBuilder<SalesPostCubit, SalesPostState>(
      builder: (context, salesPostState) {
        final showLoadingByType =
            salesPostListType == SalesPostListType.marketLocally
                ? salesPostState.isSalesPostByNeighboursDataLoading
                : salesPostState.isSalesPostByYouDataLoading;

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

        if (salesPostState.error != null) {
          return ErrorTextWidget(error: salesPostState.error!);
        } else if (showLoadingByType) {
          return const SquareGridShimmerBuilder();
        } else {
          final salesPostDataModel =
              salesPostListType == SalesPostListType.marketLocally
                  ? salesPostState.salesPostDataModel.salesPostByNeighbours
                  : salesPostState.salesPostDataModel.salesPostByYou;

          final logs = salesPostDataModel.data;
          if (logs.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: const EmptyDataPlaceHolder(
                emptyDataType: EmptyDataType.buysell,
              ),
            );
          } else {
            return DataListWithMapViewWidget(
              onRefresh: () => context
                  .read<SalesPostCubit>()
                  .fetchSalesPost(salesPostListType: salesPostListType),
              customMarker: PNGAssetsImages.buySellMapMarker,
              initialLocation: marketPlaceLocation,
              coveredAreaRadius: marketPlaceCoveredAreaRadius,
              clusterMarkerList: logs
                  .map(
                    (e) => ClusterMarkerModel(
                      id: e.id,
                      maskLocation: e.hideExactLocation,
                      latlng: LatLng(
                        e.taggedLocation.latitude,
                        e.taggedLocation.longitude,
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
                      builder: (context, searchQuery) => RenderBuySellGrid(
                        logs: selectedMarkers
                            .map((e) => logs
                                .firstWhere((element) => element.id == e.id))

                            //search filter
                            .where(
                                (element) => element.searchKeyword(searchQuery))
                            .toList(),
                        reFreshParentData: () {
                          //Close the bottom sheet
                          Navigator.pop(context);

                          //Refresh the parent data
                          reFreshParentData?.call();
                        },
                      ),
                    );
                  },
                );
              },
              onListType: RenderBuySellGrid(
                logs: logs,
                isLastPage: salesPostDataModel.paginationModel.isLastPage,
                onPagination: onPagination,
                reFreshParentData: reFreshParentData,
              ),
            );
          }
        }
      },
    );
  }
}

class RenderBuySellGrid extends StatefulWidget {
  const RenderBuySellGrid({
    super.key,
    required this.logs,
    this.isLastPage = true,
    this.onPagination,
    required this.reFreshParentData,
  });

  final List<SalesPostShortDetailsModel> logs;
  final bool isLastPage;
  final void Function()? onPagination;
  final void Function()? reFreshParentData;

  @override
  State<RenderBuySellGrid> createState() => _RenderBuySellGridState();
}

class _RenderBuySellGridState extends State<RenderBuySellGrid> {
  final salesPostScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Listening for the scrolling speed
      salesPostScrollController.position.isScrollingNotifier.addListener(() {
        //////
        if (salesPostScrollController.position.maxScrollExtent ==
            salesPostScrollController.offset) {
          widget.onPagination?.call();
        }
      });

      ManageBottomBarVisibilityOnScroll(context)
          .init(salesPostScrollController);
    });
  }

  @override
  void dispose() {
    salesPostScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomBarNavigatorCubit, BottomBarNavigatorState>(
      listener: (context, bottomBarNavigationState) async {
        if (bottomBarNavigationState.currentSelectedScreenIndex == 3) {
          await scrollToStart(salesPostScrollController);
        }
      },
      child: GridView.builder(
        controller: salesPostScrollController,
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
          childAspectRatio: 1.1,
        ),
        itemCount: widget.logs.length + 1,
        itemBuilder: (BuildContext context, index) {
          if (index < widget.logs.length) {
            final salesPostDetails = widget.logs[index];
            return MultiBlocProvider(
              key: ValueKey(salesPostDetails.id),
              providers: [
                BlocProvider(
                  create: (context) => PostActionCubit(PostActionRepository()),
                ),
              ],
              child: BlocListener<PostActionCubit, PostActionState>(
                listener: (context, postActionState) {
                  if (postActionState.isDeleteRequestSuccess) {
                    context.read<SalesPostCubit>().removePost(index);
                  }
                },
                child: SalesPostShortDetailsGridWidget(
                  salesPostDetails: salesPostDetails,
                  onRemoveItem: () {
                    widget.reFreshParentData?.call();
                  },
                ),
              ),
            );
          } else {
            return Visibility(
              visible: !widget.isLastPage,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: ThemeSpinner(size: 30),
              ),
            );
          }
        },
      ),
    );
  }
}
