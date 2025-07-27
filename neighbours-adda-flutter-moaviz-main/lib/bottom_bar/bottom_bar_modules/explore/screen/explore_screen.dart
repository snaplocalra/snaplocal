// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_list/business_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/repository/business_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/business_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/logic/explore_search/explore_search_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/logic/home_search_category_type/home_search_category_type_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/logic/post_view_filter/post_view_filter_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/repository/home_search_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/find_locally_filter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/home_search_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/neighbours_list_view_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/social_media_map_list_view_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_list_tile_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/logic/sales_post/sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/repository/sales_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/buy_sell_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/jobs/jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/repository/jobs_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/jobs_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_tile_widget.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/widgets/profile_details_widget_shimmer.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../profile/connections/logic/profile_connection/profile_connection_cubit.dart';
import '../../../../profile/connections/models/profile_connection_type.dart';
import '../../../../profile/connections/repository/profile_conenction_repository.dart';
import '../../../../profile/connections/widgets/profile_connection_widget.dart';
import '../../../../tutorial_screens/tutorial_logic/logic.dart';

class ExploreScreen extends StatefulWidget {
  final bool isPushedRoute;
  const ExploreScreen({
    super.key,
    this.isPushedRoute = false,
  });
  static const routeName = 'home_search';

  @override
  State<ExploreScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<ExploreScreen> {
  final homeSearchScrollController = ScrollController();
  late ProfileConnectionsCubit connectionsCubit = ProfileConnectionsCubit(ProfileConnectionRepository());

  //business list cubit
  late BusinessListCubit businessListCubit =
      BusinessListCubit(context.read<BusinessListRepository>());

  //buy sell list cubit
  final salesPostCubit = SalesPostCubit(SalesPostRepository());

  //jobs list cubit
  final jobsCubit = JobsCubit(JobsRepository());

  late ExploreSearchCubit exploreSearchCubit = ExploreSearchCubit(
    groupListRepository: GroupListRepository(),
    pageListRepository: PageListRepository(),
    homeSearchRepository: ExploreRepository(),
    businessListCubit: businessListCubit,
    salesPostCubit: salesPostCubit,
    jobsCubit: jobsCubit,
  );

  final homeSearchCategoryTypeCubit = ExploreCategoryTypeCubit();
  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();
  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  //Initialize the homeSearchTypeEnum with the default value
  ExploreCategoryTypeEnum homeSearchTypeEnum =
      ExploreCategoryTypeEnum.neighbours;

  final postViewFilterCubit = PostViewFilterCubit()..selectViewFilter(0);

  Future<void> searchForSocialPosts({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    PostType? postType,
    String? filterJson,
  }) async {
    await exploreSearchCubit.searchForSocialPosts(
      loadMoreData: loadMoreData,
      disableLoading: disableLoading,
      showSearchLoading: showSearchLoading,
      postType: postType,
      filterJson: filterJson,
    );
  }
  Future<void> searchForConnectionPosts({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    String? filterJson,
  }) async {
    await exploreSearchCubit.searchForConnectionPosts(
      loadMoreData: loadMoreData,
      disableLoading: disableLoading,
      showSearchLoading: showSearchLoading,
      filterJson: filterJson,
    );
  }

  Future<void> fetchExploreDataByType({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
  }) async {
    switch (homeSearchTypeEnum) {
      case ExploreCategoryTypeEnum.neighbours:
        await exploreSearchCubit.searchForNeighbours(
          loadMoreData: loadMoreData,
          disableLoading: disableLoading,
          showSearchLoading: showSearchLoading,
        );
        return;
      case ExploreCategoryTypeEnum.connections:
        await exploreSearchCubit.searchForNeighbours(
          loadMoreData: loadMoreData,
          disableLoading: disableLoading,
          showSearchLoading: showSearchLoading,
        );
        return;
      case ExploreCategoryTypeEnum.posts:
        await searchForSocialPosts(
          loadMoreData: loadMoreData,
          disableLoading: disableLoading,
          showSearchLoading: showSearchLoading,
          postType: postViewFilterCubit.state.selectedViewFilter!.postType,
        );
        return;

      case ExploreCategoryTypeEnum.business:
        //fetch all business data
        await exploreSearchCubit.searchForBusiness(
            showSearchLoading: showSearchLoading);
        return;

      case ExploreCategoryTypeEnum.buyAndsell:
        //fetch all sales post data
        await exploreSearchCubit.searchForSalesPost(
            showSearchLoading: showSearchLoading);
        return;
      case ExploreCategoryTypeEnum.jobs:
        //Job post data fetch
        await exploreSearchCubit.searchForJobs(
            showSearchLoading: showSearchLoading);
        return;
      case ExploreCategoryTypeEnum.safetyAndAlerts:
      case ExploreCategoryTypeEnum.lostAndFound:
      case ExploreCategoryTypeEnum.event:
        searchForSocialPosts(
          postType: checkPostType(homeSearchTypeEnum.displayName),
        );
        return;
      case ExploreCategoryTypeEnum.pages:
        await exploreSearchCubit.searchForPage(
          loadMoreData: loadMoreData,
          disableLoading: disableLoading,
          showSearchLoading: showSearchLoading,
        );
        return;
      case ExploreCategoryTypeEnum.groups:
        await exploreSearchCubit.searchForGroup(
          loadMoreData: loadMoreData,
          disableLoading: disableLoading,
          showSearchLoading: showSearchLoading,
        );
        return;
      default:
        return;
    }
  }

  PostType checkPostType(String displayText) {
    switch (displayText) {
      case LocaleKeys.all:
        return PostType.all;
      case LocaleKeys.general:
        return PostType.general;
      case LocaleKeys.lostAndFound:
        return PostType.lostFound;
      case LocaleKeys.safetyAndAlerts:
        return PostType.safety;
      case LocaleKeys.event:
        return PostType.event;
      case LocaleKeys.poll:
        return PostType.poll;
      case LocaleKeys.question:
        return PostType.askQuestion;
      case LocaleKeys.suggestion:
        return PostType.askSuggestion;
      case LocaleKeys.sharedPost:
        return PostType.sharedPost;
      default:
        throw Exception("Unknown post type: $displayText");
    }
  }

  late LocationAddressWithLatLng socialMediaLocationModel;
  late double socialMediaCoveredAreaRadius;

  @override
  void initState() {
    super.initState();

    connectionsCubit.fetchConnections();
    searchForConnectionPosts();

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    //Here this "socialMediaLocation" will never be null
    //because the home screen will come after the user uploaded the social media location
    socialMediaLocationModel = profileSettingsModel.socialMediaLocation!;

    //The user selected social media covered area radius
    socialMediaCoveredAreaRadius =
        profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      homeSearchCategoryTypeCubit.selectDefaultType();
    });

    //Initial data fetch
    fetchExploreDataByType();

    homeSearchScrollController.addListener(() {
      showReactionCubit.closeReactionEmojiOption();
      if (homeSearchScrollController.position.maxScrollExtent ==
          homeSearchScrollController.offset) {
        if (homeSearchTypeEnum.isFindLocally) {
          return;
        }
        fetchExploreDataByType(loadMoreData: true);
      }
    });

    //listen for the postViewFilterCubit state changes
    postViewFilterCubit.stream.listen((state) {
      if (state.allowFetchData) {
        searchForSocialPosts(
          postType: postViewFilterCubit.state.selectedViewFilter?.postType,
        );
      }
    });
    //handleExploresTutorial(context);
  }

  @override
  void dispose() {
    homeSearchScrollController.dispose();
    super.dispose();
  }

  Widget neighboursData() => BlocProvider.value(
        value: dataOnMapViewControllerCubit,
        child: Builder(
          builder: (context) {
            return BlocBuilder<ExploreSearchCubit, ExploreState>(
              builder: (context, neighboursSearchState) {
                final neighboursSearchData =
                    neighboursSearchState.neighboursSearchList;

                //Error display
                if (neighboursSearchState.error != null) {
                  return ErrorTextWidget(error: neighboursSearchState.error!);
                }
                //Shimmer
                else if (neighboursSearchData == null ||
                    neighboursSearchState.dataLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: 8,
                    itemBuilder: (context, _) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(10), // Add border radius here
                      ),
                      child: const ProfileDetailsWidgetShimmer(
                        circleSize: 90,
                      ),
                    ),
                  );
                }

                //Data display
                else {
                  final logs = neighboursSearchData.data;
                  if (logs.isEmpty) {
                    return ErrorTextWidget(
                      error: tr(LocaleKeys.noNeighbourFound),
                    );
                  } else {
                    return DataListWithMapViewWidget(
                      onRefresh: () => fetchExploreDataByType(),
                      enableMaxZoom: true,
                      customMarker: PNGAssetsImages.maleMapMarker,
                      initialLocation: LatLng(
                        socialMediaLocationModel.latitude,
                        socialMediaLocationModel.longitude,
                      ),
                      coveredAreaRadius: socialMediaCoveredAreaRadius,
                      clusterMarkerList: logs
                          .map(
                            (e) => ClusterMarkerModel(
                              id: e.id,
                              latlng: LatLng(
                                e.location!.latitude,
                                e.location!.longitude,
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
                              builder: (context, searchQuery) =>
                                  NeighboursListView(
                                homeSearchScrollController:
                                    homeSearchScrollController,
                                neighboursList: selectedMarkers
                                    .map((e) => logs.firstWhere(
                                        (element) => element.id == e.id))
                                    .where((element) {
                                  return searchQuery == null ||
                                          searchQuery.isEmpty
                                      ? true
                                      : element.name
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase());
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      onListType: NeighboursListView(
                        physics: const NeverScrollableScrollPhysics(),
                        listPadding: const EdgeInsets.all(5),
                        homeSearchScrollController: homeSearchScrollController,
                        neighboursList: logs,
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      );

  Widget connectionData() {
    final ValueNotifier<int> selectedTab = ValueNotifier(0);

    return Column(
      children: [
        // Button Tabs
        ValueListenableBuilder(
          valueListenable: selectedTab,
          builder: (context, int value, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectedTab.value = 0,
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: value == 0
                              ? ApplicationColours.themeBlueColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),

                        alignment: Alignment.center,

                        child: Text(
                        "My Local Connections",
                          style: TextStyle(
                            color: value == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectedTab.value = 1,
                      child: Container(
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: value == 1
                              ? ApplicationColours.themeBlueColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Connection’s Posts",
                          style: TextStyle(
                            color: value == 1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Content
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: selectedTab,
            builder: (context, int value, _) {
              return BlocProvider.value(
                value: connectionsCubit,
                child: value == 0
                    ? Container(
                  color: Colors.white,
                  child: BlocBuilder<ProfileConnectionsCubit, ProfileConnectionsState>(
                    builder: (context, connectionState) {
                      if (connectionState.error != null) {
                        return ErrorTextWidget(error: connectionState.error!);
                      } else if (connectionState.connectionListModel == null ||
                          connectionState.isMyConenctionDataLoading) {
                        return const CircleCardShimmerListBuilder(
                          padding: EdgeInsets.symmetric(vertical: 20),
                        );
                      } else {
                        final logs = connectionState.connectionListModel.myConnections.data;
                        if (logs.isEmpty) {
                          return ErrorTextWidget(error: "No connection found");
                        } else {
                          return RefreshIndicator.adaptive(
                            onRefresh: () => connectionsCubit.fetchConnections(
                              profileConnectionType: ProfileConnectionType.myConnections,
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              controller: homeSearchScrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: logs.length + 1,
                              itemBuilder: (BuildContext context, index) {
                                if (index < logs.length) {
                                  final connectionDetails = logs[index];
                                  return ProfileConnectionWidget(
                                    key: ValueKey(connectionDetails.id),
                                    requestedUserId: connectionDetails.requestedUserId,
                                    connectionId: connectionDetails.id,
                                    imageUrl: connectionDetails.requestedUserImage,
                                    name: connectionDetails.requestedUserName,
                                    address: connectionDetails.address,
                                    isVerified: connectionDetails.isVerified,
                                    connectionType: ProfileConnectionType.myConnections,
                                  );
                                } else {
                                  if (connectionState
                                      .connectionListModel
                                      .myConnections
                                      .paginationModel
                                      .isLastPage) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
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
                )
                    : feedConnectionPostData(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget feedPostData({bool disablePagination = false}) =>
      BlocBuilder<ExploreSearchCubit, ExploreState>(
        builder: (context, feedPostSearchState) {
          final feedPostSearchData = feedPostSearchState.feedPostsSearchList;
          if (feedPostSearchState.error != null) {
            return ErrorTextWidget(error: feedPostSearchState.error!);
          } else if (feedPostSearchData == null ||
              feedPostSearchState.dataLoading) {
            return const PostListShimmer();
          } else {
            final logs = feedPostSearchData.socialPostList;
            if (logs.isEmpty) {
              return const Center(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child:
                      EmptyDataPlaceHolder(emptyDataType: EmptyDataType.post),
                ),
              );
            } else {
              return SocialMediaMapListViewWidget(
                socialPosts: logs,
                initialLocation: LatLng(
                  socialMediaLocationModel.latitude,
                  socialMediaLocationModel.longitude,
                ),
                coveredAreaRadius: socialMediaCoveredAreaRadius,
                customMarker: logs.isEmpty
                    ? null
                    : logs.first.postType == PostType.lostFound
                        ? PNGAssetsImages.lostFoundMapMarker
                        : logs.first.postType == PostType.safety
                            ? PNGAssetsImages.safetyMapMarker
                            : logs.first.postType == PostType.event
                                ? PNGAssetsImages.eventMapMarker
                                : null,
                child: SocialPostListBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollController: homeSearchScrollController,
                  hideEmptyPlaceHolder: true,
                  showBottomDivider: false,
                  visibilityDetectorKeyValue: "explore-pagination-loading-key",
                  socialPostsModel: feedPostSearchData,
                  onPaginationDataFetch: disablePagination
                      ? null
                      : () {
                          fetchExploreDataByType(loadMoreData: true);
                        },
                ),
                onRefresh: () => fetchExploreDataByType(),
              );
            }
          }
        },
      );

  Widget feedConnectionPostData({bool disablePagination = false}) =>
      BlocBuilder<ExploreSearchCubit, ExploreState>(
        builder: (context, connectionPostSearchState) {
          final connectionPostSearchData = connectionPostSearchState.connectionPostsSearchList;
          if (connectionPostSearchState.error != null) {
            return ErrorTextWidget(error: connectionPostSearchState.error!);
          } else if (connectionPostSearchData == null ||
              connectionPostSearchState.dataLoading) {
            return const PostListShimmer();
          } else {
            final logs = connectionPostSearchData.socialPostList;
            if (logs.isEmpty) {
              return const Center(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child:
                      EmptyDataPlaceHolder(emptyDataType: EmptyDataType.post),
                ),
              );
            } else {
              return SocialMediaMapListViewWidget(
                socialPosts: logs,
                initialLocation: LatLng(
                  socialMediaLocationModel.latitude,
                  socialMediaLocationModel.longitude,
                ),
                coveredAreaRadius: socialMediaCoveredAreaRadius,
                customMarker: logs.isEmpty
                    ? null
                    : logs.first.postType == PostType.lostFound
                        ? PNGAssetsImages.lostFoundMapMarker
                        : logs.first.postType == PostType.safety
                            ? PNGAssetsImages.safetyMapMarker
                            : logs.first.postType == PostType.event
                                ? PNGAssetsImages.eventMapMarker
                                : null,
                child: SocialPostListBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollController: homeSearchScrollController,
                  hideEmptyPlaceHolder: true,
                  showBottomDivider: false,
                  visibilityDetectorKeyValue: "explore-pagination-loading-key",
                  socialPostsModel: connectionPostSearchData,
                  onPaginationDataFetch: disablePagination
                      ? null
                      : () {
                          searchForConnectionPosts(loadMoreData: true);
                        },
                ),
                onRefresh: () => searchForConnectionPosts(),
              );
            }
          }
        },
      );

  Widget groupsData() => Container(
        color: Colors.white,
        child: BlocBuilder<ExploreSearchCubit, ExploreState>(
          builder: (context, groupSearchState) {
            final groupSearchData = groupSearchState.groupSearchList;
            if (groupSearchState.error != null) {
              return ErrorTextWidget(error: groupSearchState.error!);
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
                return RefreshIndicator.adaptive(
                  onRefresh: () => fetchExploreDataByType(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    controller: homeSearchScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: logs.length + 1,
                    itemBuilder: (BuildContext context, index) {
                      if (index < logs.length) {
                        final groupDetails = logs[index];
                        return GroupListTileWidget(
                          groupName: groupDetails.groupName,
                          groupDescription: groupDetails.groupDescription,
                          groupId: groupDetails.groupId,
                          groupImageUrl: groupDetails.groupImage,
                          unSeenPostCount: groupDetails.unseenPostCount,
                          isJoined: groupDetails.isJoined,
                          isGroupAdmin: groupDetails.isGroupAdmin,
                          isVerified: groupDetails.isVerified,
                        );
                      } else {
                        if (groupSearchData.paginationModel.isLastPage) {
                          return const SizedBox.shrink();
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
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
      );

  Widget pageData() => Container(
        color: Colors.white,
        child: BlocBuilder<ExploreSearchCubit, ExploreState>(
          builder: (context, pageSearchState) {
            final pageSearchData = pageSearchState.pageSearchList;
            if (pageSearchState.error != null) {
              return ErrorTextWidget(error: pageSearchState.error!);
            } else if (pageSearchData == null || pageSearchState.dataLoading) {
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
                return RefreshIndicator.adaptive(
                  onRefresh: () => fetchExploreDataByType(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    controller: homeSearchScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: logs.length + 1,
                    itemBuilder: (BuildContext context, index) {
                      if (index < logs.length) {
                        final pageDetails = logs[index];
                        return PageListTileWidget(
                          key: ValueKey(pageDetails.pageId),
                          pageName: pageDetails.pageName,
                          isVerified: pageDetails.isVerified,
                          pageDescription: pageDetails.pageDescription,
                          pageId: pageDetails.pageId,
                          pageImageUrl: pageDetails.pageImage,
                          isFollowing: pageDetails.isFollowing,
                          isPageAdmin: pageDetails.isPageAdmin,
                          isBlockByUser: pageDetails.blockedByUser,
                          isBlockByAdmin: pageDetails.blockedByAdmin,
                          unSeenPostCount: pageDetails.unseenPostCount,
                          onPageFollowUnfollow: (isFollowing) {
                            //showing quick refresh on the screen
                            pageDetails.isFollowing = isFollowing;
                            context.read<ExploreSearchCubit>().refreshState();
                          },
                          dataRefreshCallback: () {
                            exploreSearchCubit.searchForPage(
                                disableLoading: true);
                          },
                        );
                      } else {
                        if (pageSearchData.paginationModel.isLastPage) {
                          return const SizedBox.shrink();
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
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
      );

  Widget renderWidgetByType() {
    switch (homeSearchTypeEnum) {
      //Neighbours Data
      case ExploreCategoryTypeEnum.neighbours:
        return neighboursData();
      case ExploreCategoryTypeEnum.connections:
        return connectionData();

      //Feed post Data
      case ExploreCategoryTypeEnum.posts:
        return feedPostData();

      case ExploreCategoryTypeEnum.business:
        return FindLocallyWidget(
          exploreCategoryTypeEnum: homeSearchTypeEnum,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataOnMapViewControllerCubit),
              BlocProvider.value(value: businessListCubit),
            ],
            child: BusinessListBuilder(
              businessViewType: BusinessViewType.business,
              onRefresh: () async {},
            ),
          ),
          onFilter: (filterJson) {
            //fetch business data with filter
            exploreSearchCubit.searchForBusiness(filterJson: filterJson);
          },
        );
      case ExploreCategoryTypeEnum.buyAndsell:
        return FindLocallyWidget(
          exploreCategoryTypeEnum: homeSearchTypeEnum,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataOnMapViewControllerCubit),
              BlocProvider.value(value: salesPostCubit),
            ],
            child: const BuySellListBuilder(
              salesPostListType: SalesPostListType.marketLocally,
            ),
          ),
          onFilter: (filterJson) {
            //fetch sales post data with filter
            exploreSearchCubit.searchForSalesPost(filterJson: filterJson);
          },
        );
      case ExploreCategoryTypeEnum.jobs:
        return FindLocallyWidget(
          exploreCategoryTypeEnum: homeSearchTypeEnum,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataOnMapViewControllerCubit),
              BlocProvider.value(value: jobsCubit),
            ],
            child: JobsListBuilder(
              onRefresh: () => fetchExploreDataByType(),
              jobsListType: JobsListType.byNeighbours,
              scrollController: ScrollController(),
            ),
          ),
          onFilter: (filterJson) {
            //fetch jobs data with filter
            exploreSearchCubit.searchForJobs(filterJson: filterJson);
          },
        );

      case ExploreCategoryTypeEnum.safetyAndAlerts:
      case ExploreCategoryTypeEnum.lostAndFound:
      case ExploreCategoryTypeEnum.event:
        return FindLocallyWidget(
          exploreCategoryTypeEnum: homeSearchTypeEnum,
          onFilter: (filterJson) {
            searchForSocialPosts(
              postType: checkPostType(homeSearchTypeEnum.displayName),
              filterJson: filterJson,
            );
          },
          child: feedPostData(disablePagination: true),
        );

      //Page Data
      case ExploreCategoryTypeEnum.pages:
        return pageData();

      //Group Data
      case ExploreCategoryTypeEnum.groups:
        return groupsData();
      default:
        //Neighbours Data
        return neighboursData();
    }
  }

  void willPopScope() {
    if (widget.isPushedRoute) {
      Navigator.of(context).pop();
    } else {
      context.read<BottomBarNavigatorCubit>().goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: homeSearchCategoryTypeCubit),
            BlocProvider.value(value: exploreSearchCubit),
            BlocProvider.value(value: showReactionCubit),
            BlocProvider.value(value: postViewFilterCubit),
            BlocProvider.value(value: dataOnMapViewControllerCubit),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: ThemeAppBar(
              elevation: 0,
              titleSpacing: 10,
              showBackButton: widget.isPushedRoute,
              backgroundColor: Colors.white,
              title: Text(
                tr(LocaleKeys.explore),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 18,
                ),
              ),
            ),
            body: Column(children: [
              Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    //Explore Type Selector
                    ExploreTypeSelectorWidget(
                      onExploreCategoryTypeEnumSelected:
                          (newExploreTypeEnum) {
                        homeSearchTypeEnum = newExploreTypeEnum;
                      },
                      onFetchData: () {
                        fetchExploreDataByType();
                      },
                    ),
                    //search box
                    BlocBuilder<ExploreSearchCubit, ExploreState>(
                      builder: (context, homeSearchState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SearchTextField(
                            dataLoading: homeSearchState.isSearchDataLoading,
                            hint: LocaleKeys.search,
                            onQuery: (query) {
                              if (query.isNotEmpty) {
                                //Search connections
                                context
                                    .read<ExploreSearchCubit>()
                                    .setSearchQuery(query);
                              } else {
                                context
                                    .read<ExploreSearchCubit>()
                                    .clearSearchQuery();
                              }

                              fetchExploreDataByType(
                                showSearchLoading: true,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<ExploreCategoryTypeCubit, ExploreCategoryTypeState>(
                builder: (context, homeSearchCategoryTypeState) {
                  return Expanded(child: renderWidgetByType());
                },
              ),
            ]),
          ),
        );
      },
    );
  }
}

class FindLocallyWidget extends StatelessWidget {
  final ExploreCategoryTypeEnum exploreCategoryTypeEnum;
  final Widget child;
  final void Function(String) onFilter;
  const FindLocallyWidget({
    super.key,
    required this.child,
    required this.onFilter,
    required this.exploreCategoryTypeEnum,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          child: FindLocallyFilter(
            key: Key(exploreCategoryTypeEnum.name),
            exploreCategoryTypeEnum: exploreCategoryTypeEnum,
            onFilter: onFilter,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
