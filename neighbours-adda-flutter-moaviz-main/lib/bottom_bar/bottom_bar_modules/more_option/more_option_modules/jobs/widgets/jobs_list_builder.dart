import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/jobs/jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_card_shimmer.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_short_details_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class JobsListBuilder extends StatelessWidget {
  final JobsListType jobsListType;
  final ScrollController scrollController;
  final void Function()? onPagination;
  final Future<void> Function() onRefresh;

  const JobsListBuilder({
    super.key,
    required this.jobsListType,
    required this.scrollController,
    this.onPagination,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsCubit, JobsState>(
      builder: (context, jobsState) {
        final showLoadingByType = jobsListType == JobsListType.byNeighbours
            ? jobsState.isJobsByNeighboursDataLoading
            : jobsState.isJobsByYouDataLoading;

        final profileSettingsModel =
            context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

        //use for the map view
        final LatLng? marketPlaceLocation =
            profileSettingsModel.marketPlaceLocation == null
                ? null
                : LatLng(
                    profileSettingsModel.marketPlaceLocation!.latitude,
                    profileSettingsModel.marketPlaceLocation!.longitude,
                  );

        final marketPlaceCoveredAreaRadius =
            profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius;

        if (jobsState.error != null) {
          return ErrorTextWidget(error: jobsState.error!);
        } else if (showLoadingByType) {
          return const JobShortDetailsShimmerListBuilder(
            padding: EdgeInsets.symmetric(horizontal: 5),
          );
        } else {
          final jobsModel = jobsListType == JobsListType.byNeighbours
              ? jobsState.jobsDataModel.jobsByNeighbours
              : jobsState.jobsDataModel.jobsByYou;

          final logs = jobsModel.data;

          if (logs.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: const EmptyDataPlaceHolder(
                emptyDataType: EmptyDataType.job,
              ),
            );
          } else {
            return DataListWithMapViewWidget(
              controller: scrollController,
              onRefresh: onRefresh,
              customMarker: PNGAssetsImages.jobMapMarker,
              initialLocation: marketPlaceLocation,
              coveredAreaRadius: marketPlaceCoveredAreaRadius,
              clusterMarkerList: logs
                  .map(
                    (e) => ClusterMarkerModel(
                      id: e.id,
                      latlng: LatLng(
                        e.workLocation.latitude,
                        e.workLocation.longitude,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: MapViewDataListBottomSheet(
                        markersCount: selectedMarkers.length,
                        builder: (context, searchQuery) => JobListView(
                          jobsListType: jobsListType,
                          logs: selectedMarkers
                              .map((e) => logs
                                  .firstWhere((element) => element.id == e.id))
                              //search filter
                              .where((element) =>
                                  element.searchKeyword(searchQuery))
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              onListType: JobListView(
                logs: logs,
                jobsListType: jobsListType,
                isLastPage: jobsModel.paginationModel.isLastPage,
                onPagination: onPagination,
              ),
            );
          }
        }
      },
    );
  }
}

class JobListView extends StatelessWidget {
  const JobListView({
    super.key,
    required this.logs,
    required this.jobsListType,
    this.isLastPage = true,
    this.onPagination,
  });

  final List<JobShortDetailsModel> logs;
  final JobsListType jobsListType;
  final bool isLastPage;
  final void Function()? onPagination;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      shrinkWrap: true,
      itemCount: logs.length + 1,
      itemBuilder: (BuildContext context, index) {
        if (index < logs.length) {
          final jobsDetails = logs[index];
          return MultiBlocProvider(
            key: ValueKey(jobsDetails.id),
            providers: [
              BlocProvider(
                create: (context) => JobShortViewControllerCubit(
                  jobShortDetailsModel: jobsDetails,
                ),
              ),
            ],
            child: const JobShortDetailsWidget(),
          );
        } else {
          return Visibility(
            visible: !isLastPage,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: ThemeSpinner(size: 40),
            ),
          );
        }
      },
    );
  }
}
