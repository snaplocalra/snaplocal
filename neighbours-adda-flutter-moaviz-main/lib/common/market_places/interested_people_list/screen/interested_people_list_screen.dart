import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/market_places/interested_people_list/logic/interested_people/interested_people_cubit.dart';
import 'package:snap_local/common/market_places/interested_people_list/repository/interested_people_repository.dart';
import 'package:snap_local/common/market_places/interested_people_list/widget/interested_people_details.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class InterestedPeopleListScreen extends StatefulWidget {
  final String postId;
  final MarketPlaceType marketPlaceType;

  static const routeName = 'interested_people_list';

  const InterestedPeopleListScreen({
    super.key,
    required this.postId,
    required this.marketPlaceType,
  });

  @override
  State<InterestedPeopleListScreen> createState() =>
      _InterestedPeopleListScreenState();
}

class _InterestedPeopleListScreenState
    extends State<InterestedPeopleListScreen> {
  final scrollController = ScrollController();

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  late InterestedPeopleCubit interestedPeopleCubit =
      InterestedPeopleCubit(InterestedPeopleRepository())
        ..fetchInterestedPeopleList(
          postId: widget.postId,
          marketPlaceType: widget.marketPlaceType,
        );

  late LatLng marketPlaceLocation;
  late double marketPlaceSearchRadius;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        interestedPeopleCubit.fetchInterestedPeopleList(
          loadMoreData: true,
          postId: widget.postId,
          marketPlaceType: widget.marketPlaceType,
        );
      }
    });

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    marketPlaceLocation = LatLng(
      profileSettingsModel.marketPlaceLocation!.latitude,
      profileSettingsModel.marketPlaceLocation!.longitude,
    );

    marketPlaceSearchRadius =
        profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: interestedPeopleCubit),
        BlocProvider.value(value: dataOnMapViewControllerCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: const IOSBackButton(),
          title: Text(
            tr(LocaleKeys.interested),
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            BlocBuilder<InterestedPeopleCubit, InterestedPeopleState>(
              builder: (context, interestedPeopleState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: SearchTextField(
                    dataLoading: interestedPeopleState.isSearchLoading,
                    hint: LocaleKeys.search,
                    onQuery: (query) {
                      if (query.isNotEmpty) {
                        //Search attendings
                        context
                            .read<InterestedPeopleCubit>()
                            .setSearchQuery(query);
                      } else {
                        context
                            .read<InterestedPeopleCubit>()
                            .clearSearchQuery();
                      }

                      //Fetch interested people list to search
                      context
                          .read<InterestedPeopleCubit>()
                          .fetchInterestedPeopleList(
                            postId: widget.postId,
                            showSearchLoading: true,
                            marketPlaceType: widget.marketPlaceType,
                          );
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<InterestedPeopleCubit, InterestedPeopleState>(
                builder: (context, interestedPeopleState) {
                  final eventAttendingData =
                      interestedPeopleState.interestedPeopleList;
                  return BlocBuilder<InterestedPeopleCubit,
                      InterestedPeopleState>(
                    builder: (context, interestedPeopleState) {
                      if (interestedPeopleState.error != null) {
                        return ErrorTextWidget(
                            error: interestedPeopleState.error!);
                      } else if (eventAttendingData == null ||
                          interestedPeopleState.dataLoading) {
                        return const CircleCardShimmerListBuilder(
                          padding: EdgeInsets.symmetric(vertical: 15),
                        );
                      } else {
                        final logs = eventAttendingData.data;
                        if (logs.isEmpty) {
                          return const ErrorTextWidget(error: "No user found");
                        } else {
                          return DataListWithMapViewWidget(
                            controller: scrollController,
                            customMarker: PNGAssetsImages.maleMapMarker,
                            initialLocation: marketPlaceLocation,
                            coveredAreaRadius: marketPlaceSearchRadius,
                            clusterMarkerList: logs
                                .map(
                                  (e) => ClusterMarkerModel(
                                    id: e.userId,
                                    latlng: LatLng(
                                      e.location.latitude,
                                      e.location.longitude,
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
                                    builder: (context, searchQuery) {
                                      final peopleList = selectedMarkers
                                          .map((e) => logs.firstWhere(
                                              (element) =>
                                                  element.userId == e.id))
                                          .where((element) {
                                        return searchQuery == null ||
                                                searchQuery.isEmpty
                                            ? true
                                            : element.userName
                                                .toLowerCase()
                                                .contains(
                                                    searchQuery.toLowerCase());
                                      }).toList();
                                      return ListView.builder(
                                        controller: scrollController,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: peopleList.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          final interestedPeopleModel =
                                              peopleList[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 8),
                                            child: Column(
                                              children: [
                                                InterestedPeopleDetails(
                                                  interestedPeopleModel:
                                                      interestedPeopleModel,
                                                ),
                                                const SizedBox(height: 10),
                                                const ThemeDivider(
                                                  thickness: 1,
                                                  height: 2,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            onRefresh: () => context
                                .read<InterestedPeopleCubit>()
                                .fetchInterestedPeopleList(
                                  postId: widget.postId,
                                  marketPlaceType: widget.marketPlaceType,
                                ),
                            onListType: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: logs.length + 1,
                              itemBuilder: (BuildContext context, index) {
                                if (index < logs.length) {
                                  final interestedPeopleModel = logs[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: Column(
                                      children: [
                                        InterestedPeopleDetails(
                                          interestedPeopleModel:
                                              interestedPeopleModel,
                                        ),
                                        const SizedBox(height: 10),
                                        const ThemeDivider(
                                          thickness: 1,
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  if (eventAttendingData
                                      .paginationModel.isLastPage) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: ThemeSpinner(size: 30),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
