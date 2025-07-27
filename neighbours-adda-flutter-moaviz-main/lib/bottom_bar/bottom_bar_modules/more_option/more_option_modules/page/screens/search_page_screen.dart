import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_search/page_search_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_tile_widget.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
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

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({super.key});
  static const routeName = 'search_Pages';

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  final searchPageScrollController = ScrollController();
  final pageCategoryScrollController = ScrollController();

  late PageSearchCubit pageSearchCubit =
      PageSearchCubit(pageListRepository: pageListRepository);

  late PageListRepository pageListRepository = PageListRepository();

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit()
    ..setListView();

  final filterData = FilterData();

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.pageSearchSortFilter,
    ),
  ]);

  String get filterJson => dataFilterCubit.state.filterJson;
  //assign the Job category cubit instance
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
    PageCategory(MultieSubCategorySelectionStrategy()),
  );

  @override
  void initState() {
    super.initState();

    //fetch search page data
    pageSearchCubit.searchForPage();

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    final socialMediaSearchRadius =
        profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: socialMediaSearchRadius,
      selectedMaxDistance: socialMediaSearchRadius,
    );
    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

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

    searchPageScrollController.addListener(() {
      if (searchPageScrollController.position.maxScrollExtent ==
          searchPageScrollController.offset) {
        pageSearchCubit.searchForPage(
          loadMoreData: true,
          filterJson: filterJson,
        );
      }
    });
  }

  @override
  void dispose() {
    searchPageScrollController.dispose();
    pageCategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: pageSearchCubit),
            BlocProvider.value(value: categoryControllerCubit),
            BlocProvider.value(value: dataFilterCubit),
            BlocProvider.value(value: dataOnMapViewControllerCubit),
          ],
          child: Builder(builder: (context) {
            return Scaffold(
              appBar: ThemeAppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  tr(LocaleKeys.searchPages),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SearchWithDataFilterWidget(
                          searchHint: tr(LocaleKeys.searchPages),
                          onQuery: (query) {
                            if (query.isNotEmpty) {
                              //Search connections
                              context
                                  .read<PageSearchCubit>()
                                  .setSearchQuery(query);
                            } else {
                              context
                                  .read<PageSearchCubit>()
                                  .clearSearchQuery();
                            }
                            context.read<PageSearchCubit>().searchForPage(
                                  filterJson: context
                                      .read<DataFilterCubit>()
                                      .state
                                      .filterJson,
                                  disableLoading: true,
                                  showSearchLoading: true,
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
                                .read<PageSearchCubit>()
                                .searchForPage(filterJson: filterJson);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: BlocBuilder<PageSearchCubit, PageSearchState>(
                        builder: (context, pageSearchState) {
                          final pageSearchData = pageSearchState.pageSearchList;
                          if (pageSearchState.error != null) {
                            return ErrorTextWidget(
                                error: pageSearchState.error!);
                          } else if (pageSearchData == null ||
                              pageSearchState.dataLoading) {
                            return const CircleCardShimmerListBuilder(
                              padding: EdgeInsets.symmetric(vertical: 20),
                            );
                          } else {
                            final logs = pageSearchData.data;
                            if (logs.isEmpty) {
                              return const Center(
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: EmptyDataPlaceHolder(
                                    emptyDataType: EmptyDataType.page,
                                  ),
                                ),
                              );
                            } else {
                              final profileSettingsModel = context
                                  .read<ProfileSettingsCubit>()
                                  .state
                                  .profileSettingsModel!;
                              final socialMediaSearchRadius =
                                  profileSettingsModel
                                      .feedRadiusModel.socialMediaSearchRadius;
                              final socialMediaLocation =
                                  profileSettingsModel.socialMediaLocation;

                              return DataListWithMapViewWidget(
                                onRefresh: () => context
                                    .read<PageSearchCubit>()
                                    .searchForPage(filterJson: filterJson),
                                controller: searchPageScrollController,
                                customMarker: PNGAssetsImages.pageMapMarker,
                                initialLocation:
                                    socialMediaLocation!.toLatLng(),
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
                                            final filteredMarkers =
                                                selectedMarkers
                                                    .map(
                                                      (e) => logs.firstWhere(
                                                        (element) =>
                                                            element.pageId ==
                                                            e.id,
                                                      ),
                                                    )

                                                    //search filter
                                                    .where((element) =>
                                                        element.searchKeyword(
                                                            searchQuery))
                                                    .toList();
                                            return ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              controller:
                                                  searchPageScrollController,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount: filteredMarkers.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                final pageDetails =
                                                    filteredMarkers[index];
                                                return PageListTileWidget(
                                                  key: ValueKey(
                                                      pageDetails.pageId),
                                                  pageName:
                                                      pageDetails.pageName,
                                                  isVerified: pageDetails.isVerified,
                                                  pageDescription: pageDetails
                                                      .pageDescription,
                                                  pageId: pageDetails.pageId,
                                                  pageImageUrl:
                                                      pageDetails.pageImage,
                                                  isFollowing:
                                                      pageDetails.isFollowing,
                                                  isPageAdmin:
                                                      pageDetails.isPageAdmin,
                                                  isBlockByUser:
                                                      pageDetails.blockedByUser,
                                                  isBlockByAdmin: pageDetails
                                                      .blockedByAdmin,
                                                  unSeenPostCount: pageDetails
                                                      .unseenPostCount,
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
                                      final pageDetails = logs[index];
                                      return PageListTileWidget(
                                        key: ValueKey(pageDetails.pageId),
                                        unSeenPostCount:
                                            pageDetails.unseenPostCount,
                                        pageName: pageDetails.pageName,
                                        isVerified: pageDetails.isVerified,
                                        pageDescription:
                                            pageDetails.pageDescription,
                                        pageId: pageDetails.pageId,
                                        pageImageUrl: pageDetails.pageImage,
                                        isFollowing: pageDetails.isFollowing,
                                        isPageAdmin: pageDetails.isPageAdmin,
                                        isBlockByUser:
                                            pageDetails.blockedByUser,
                                        isBlockByAdmin:
                                            pageDetails.blockedByAdmin,
                                        onPageFollowUnfollow: (isFollowing) {
                                          //showing quick refresh on the screen
                                          pageDetails.isFollowing = isFollowing;
                                          context
                                              .read<PageSearchCubit>()
                                              .refreshPageOnFollowUnfollow();
                                        },
                                        dataRefreshCallback: () {
                                          pageSearchCubit.searchForPage(
                                            filterJson: filterJson,
                                            disableLoading: true,
                                          );
                                        },
                                      );
                                    } else {
                                      if (pageSearchData
                                          .paginationModel.isLastPage) {
                                        return const SizedBox.shrink();
                                      } else {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
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
