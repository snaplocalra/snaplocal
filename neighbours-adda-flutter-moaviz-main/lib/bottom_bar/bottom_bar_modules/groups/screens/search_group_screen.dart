import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_search/group_search_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_list_tile_widget.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/filter_data.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SearchGroupScreen extends StatefulWidget {
  const SearchGroupScreen({super.key});
  static const routeName = 'search_groups';

  @override
  State<SearchGroupScreen> createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends State<SearchGroupScreen>
    with TickerProviderStateMixin {
  final searchGroupScrollController = ScrollController();

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit()
    ..setListView();

  late GroupSearchCubit groupSearchCubit =
      GroupSearchCubit(groupListRepository: groupListRepository)
        ..searchForGroup();

  late GroupListRepository groupListRepository = GroupListRepository();
  //assign the Group category cubit instance
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          GroupCategory(MultieSubCategorySelectionStrategy()));
  final filterData = FilterData();

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.groupSearchSortFilter,
    ),

    //Group type
    ...filterData.groupTypeFilter,
  ]);

  String get filterJson => dataFilterCubit.state.filterJson;

  @override
  void initState() {
    super.initState();

    //listen for the search group scroll controller
    searchGroupScrollController.addListener(() {
      if (searchGroupScrollController.position.maxScrollExtent ==
          searchGroupScrollController.offset) {
        groupSearchCubit.searchForGroup(
          loadMoreData: true,
          filterJson: filterJson,
        );
      }
    });

    //Load the categories
    categoryControllerCubit.fetchCategories();

    //listen for the category filter changes
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded && state.isFirstLoad) {
        dataFilterCubit.insertOrUpdateFilter(
          CategoryFilter(
            filterName: "Category",
            jsonKey: "category",
            categoryControllerCubit: categoryControllerCubit,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    searchGroupScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: groupSearchCubit),
            BlocProvider.value(value: categoryControllerCubit),
            BlocProvider.value(value: dataOnMapViewControllerCubit),
            BlocProvider.value(value: dataFilterCubit),
          ],
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: ThemeAppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  tr(LocaleKeys.groups),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<GroupSearchCubit, GroupSearchState>(
                          builder: (context, groupSearchState) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                              child: SearchWithDataFilterWidget(
                                searchHint: tr(LocaleKeys.searchGroup),
                                onQuery: (query) {
                                  if (query.isNotEmpty) {
                                    //Search connections
                                    context
                                        .read<GroupSearchCubit>()
                                        .setSearchQuery(query);
                                  } else {
                                    context
                                        .read<GroupSearchCubit>()
                                        .clearSearchQuery();
                                  }
                                  context
                                      .read<GroupSearchCubit>()
                                      .searchForGroup(
                                        filterJson: filterJson,
                                        disableLoading: true,
                                        showSearchLoading: true,
                                      );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        //Data filter
                        DataFilterMenu(
                          categoryControllerCubit:
                              context.read<CategoryControllerCubit>(),
                          onFilterApply: () {
                            context
                                .read<GroupSearchCubit>()
                                .searchForGroup(filterJson: filterJson);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<GroupSearchCubit, GroupSearchState>(
                      builder: (context, groupSearchState) {
                        final groupSearchData =
                            groupSearchState.groupSearchList;

                        if (groupSearchState.error != null) {
                          return ErrorTextWidget(
                              error: groupSearchState.error!);
                        } else if (groupSearchData == null ||
                            groupSearchState.dataLoading) {
                          return const CircleCardShimmerListBuilder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          );
                        } else {
                          final logs = groupSearchData.data;
                          if (logs.isEmpty) {
                            return const Center(
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: EmptyDataPlaceHolder(
                                  emptyDataType: EmptyDataType.group,
                                ),
                              ),
                            );
                          } else {
                            final profileSettingsModel = context
                                .read<ProfileSettingsCubit>()
                                .state
                                .profileSettingsModel!;
                            final socialMediaSearchRadius = profileSettingsModel
                                .feedRadiusModel.socialMediaSearchRadius;
                            final socialMediaLocation =
                                profileSettingsModel.socialMediaLocation;
                            return DataListWithMapViewWidget(
                              onRefresh: () => context
                                  .read<GroupSearchCubit>()
                                  .searchForGroup(filterJson: filterJson),
                              controller: searchGroupScrollController,
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
                                          final filteredMarkers =
                                              selectedMarkers
                                                  .map(
                                                    (e) => logs.firstWhere(
                                                      (element) =>
                                                          element.groupId ==
                                                          e.id,
                                                    ),
                                                  )

                                                  //search filter
                                                  .where(
                                                    (element) =>
                                                        element.searchKeyword(
                                                      searchQuery,
                                                    ),
                                                  )
                                                  .toList();
                                          return ListView.builder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            controller:
                                                searchGroupScrollController,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: filteredMarkers.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              final groupDetails =
                                                  filteredMarkers[index];
                                              return GroupListTileWidget(
                                                key: ValueKey(
                                                    groupDetails.groupId),
                                                groupName:
                                                    groupDetails.groupName,
                                                groupDescription: groupDetails
                                                    .groupDescription,
                                                groupId: groupDetails.groupId,
                                                groupImageUrl:
                                                    groupDetails.groupImage,
                                                unSeenPostCount: groupDetails
                                                    .unseenPostCount,
                                                isJoined: groupDetails.isJoined,
                                                isGroupAdmin:
                                                    groupDetails.isGroupAdmin,
                                                isVerified: groupDetails.isVerified,
                                              );
                                            },
                                          );
                                        });
                                  },
                                );
                              },
                              onListType: ListView.builder(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: logs.length + 1,
                                itemBuilder: (BuildContext context, index) {
                                  if (index < logs.length) {
                                    final groupDetails = logs[index];
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
                                        //update the join status
                                        groupDetails.isJoined = isJoined;

                                        //refresh the state
                                        context
                                            .read<GroupSearchCubit>()
                                            .refreshState();
                                      },
                                    );
                                  } else {
                                    if (groupSearchData
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
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
