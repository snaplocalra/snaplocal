import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/logic/event_list/event_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/widgets/event_short_details_list_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/widgets/custom_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/rectangle_list_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class EventListBuilder extends StatelessWidget {
  final EventPostListType eventPostListType;
  final bool isOwnPost;
  final Future<void> Function() onRefresh;
  final void Function() onPagination;
  const EventListBuilder({
    super.key,
    required this.eventPostListType,
    required this.onRefresh,
    required this.onPagination,
    this.isOwnPost = false,
  });

  @override
  Widget build(BuildContext context) {
    return //Sales post data
        BlocBuilder<EventListCubit, EventListState>(
      builder: (context, eventListState) {
        final profileSettingsModel =
            context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

        final LatLng? socialMediaLocation =
            profileSettingsModel.socialMediaLocation == null
                ? null
                : LatLng(
                    profileSettingsModel.socialMediaLocation!.latitude,
                    profileSettingsModel.socialMediaLocation!.longitude,
                  );

        final socialMediaCoveredAreaRadius =
            profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius;

        final showLoadingByType =
            eventPostListType == EventPostListType.localEvents
                ? eventListState.isLocalEventDataLoading
                : eventListState.isLocalEventDataLoading;
        if (eventListState.error != null) {
          return ErrorTextWidget(error: eventListState.error!);
        } else if (showLoadingByType) {
          return const ReactangleListShimmerBuilder();
        } else {
          final eventPostDataModel =
              eventPostListType == EventPostListType.localEvents
                  ? eventListState.eventPostDataModel.localEvents
                  : eventListState.eventPostDataModel.myEvents;

          final logs = eventPostDataModel.data;
          if (logs.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: const EmptyDataPlaceHolder(
                emptyDataType: EmptyDataType.event,
              ),
            );
          } else {
            return DataListWithMapViewWidget(
              customMarker: PNGAssetsImages.eventMapMarker,
              initialLocation: socialMediaLocation,
              coveredAreaRadius: socialMediaCoveredAreaRadius,
              onRefresh: onRefresh,
              clusterMarkerList: logs
                  .map(
                    (e) => ClusterMarkerModel(
                      id: e.id,
                      latlng: LatLng(
                        e.taggedlocation!.latitude,
                        e.taggedlocation!.longitude,
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
                    return CustomBottomSheet(
                      child: EventListView(
                        eventPostListType: eventPostListType,
                        logs: logs
                            .where((element) => selectedMarkers
                                .map((e) => e.id)
                                .contains(element.id))
                            .toList(),
                      ),
                    );
                  },
                );
              },
              onListType: EventListView(
                logs: logs,
                onPagination: onPagination,
                isLastPage: eventPostDataModel.paginationModel.isLastPage,
                eventPostListType: eventPostListType,
              ),
            );
          }
        }
      },
    );
  }
}

class EventListView extends StatefulWidget {
  const EventListView({
    super.key,
    required this.logs,
    this.isLastPage = true,
    required this.eventPostListType,
    this.onPagination,
  });

  final List<EventPostModel> logs;
  final bool isLastPage;
  final EventPostListType eventPostListType;
  final void Function()? onPagination;

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  final eventScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Listening for the scrolling speed
      eventScrollController.position.isScrollingNotifier.addListener(() {
        //////
        if (eventScrollController.position.maxScrollExtent ==
            eventScrollController.offset) {
          widget.onPagination?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    eventScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: eventScrollController,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      itemCount: widget.logs.length + 1,
      itemBuilder: (BuildContext context, index) {
        if (index < widget.logs.length) {
          final eventPostDetails = widget.logs[index];

          return MultiBlocProvider(
            key: ValueKey(eventPostDetails.id),
            providers: [
              BlocProvider(
                create: (_) => PostActionCubit(PostActionRepository()),
              ),
              BlocProvider(
                create: (_) => PostDetailsControllerCubit(
                    socialPostModel: eventPostDetails),
              ),
            ],
            child: BlocListener<PostActionCubit, PostActionState>(
              listener: (context, postActionState) {
                if (postActionState.isDeleteRequestSuccess) {
                  context.read<EventListCubit>().removePost(index);
                }
              },
              child: const EventShortDetailsListWidget(),
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
    );
  }
}
