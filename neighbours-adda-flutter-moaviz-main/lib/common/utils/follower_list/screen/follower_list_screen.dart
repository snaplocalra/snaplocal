import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/follower_list/logic/followers_list/followers_list_cubit.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_list_impl.dart';
import 'package:snap_local/common/utils/follower_list/repository/follower_list_repository.dart';
import 'package:snap_local/common/utils/follower_list/widget/follower_details.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class FollowerListScreen extends StatefulWidget {
  final FollowerListImpl followerListImpl;
  final String postId;

  static const routeName = 'follower_list';
  const FollowerListScreen({
    super.key,
    required this.followerListImpl,
    required this.postId,
  });

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final scrollController = ScrollController();
  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();
  late FollowersListCubit followersListCubit =
      FollowersListCubit(FollowerListRepository())
        ..fetchFollowerList(
          postId: widget.postId,
          followersFrom: widget.followerListImpl.followerFrom,
        );

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        followersListCubit.fetchFollowerList(
          loadMoreData: true,
          postId: widget.postId,
          followersFrom: widget.followerListImpl.followerFrom,
        );
      }
    });
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
        BlocProvider.value(value: dataOnMapViewControllerCubit),
        BlocProvider.value(value: followersListCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: const IOSBackButton(),
          title: Text(
            widget.followerListImpl.title,
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.followerListImpl.heading(context),
            BlocBuilder<FollowersListCubit, FollowersListState>(
              builder: (context, followerState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: SearchTextField(
                    dataLoading: followerState.isSearchLoading,
                    hint: LocaleKeys.search,
                    onQuery: (query) {
                      if (query.isNotEmpty) {
                        //Search attendings
                        context
                            .read<FollowersListCubit>()
                            .setSearchQuery(query);
                      } else {
                        context.read<FollowersListCubit>().clearSearchQuery();
                      }

                      //Fetch interested people list to search
                      context.read<FollowersListCubit>().fetchFollowerList(
                            postId: widget.postId,
                            showSearchLoading: true,
                            followersFrom: widget.followerListImpl.followerFrom,
                          );
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<FollowersListCubit, FollowersListState>(
                builder: (context, followerState) {
                  final followerList = followerState.followerList;
                  return BlocBuilder<FollowersListCubit, FollowersListState>(
                    builder: (context, followerState) {
                      if (followerState.error != null) {
                        return ErrorTextWidget(error: followerState.error!);
                      } else if (followerList == null ||
                          followerState.dataLoading) {
                        return const CircleCardShimmerListBuilder(
                          padding: EdgeInsets.symmetric(vertical: 15),
                        );
                      } else {
                        final logs = followerList.data;
                        if (logs.isEmpty) {
                          return const ErrorTextWidget(error: "No user found");
                        } else {
                          return DataListWithMapViewWidget(
                            controller: scrollController,
                            onRefresh: () => context
                                .read<FollowersListCubit>()
                                .fetchFollowerList(
                                  postId: widget.postId,
                                  showSearchLoading: true,
                                  followersFrom:
                                      widget.followerListImpl.followerFrom,
                                ),
                            customMarker: PNGAssetsImages.maleMapMarker,
                            initialLocation: widget.followerListImpl.latLng,
                            coveredAreaRadius:
                                widget.followerListImpl.searchRadius,
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
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: context.read<FollowersListCubit>(),
                                    child: BlocBuilder<FollowersListCubit,
                                        FollowersListState>(
                                      builder: (context, followerState) {
                                        final followerList =
                                            followerState.followerList!.data;
                                        return MapViewDataListBottomSheet(
                                          markersCount: selectedMarkers.length,
                                          builder: (context, searchQuery) {
                                            final peopleList = selectedMarkers
                                                .map((e) => followerList
                                                    .firstWhere((element) =>
                                                        element.userId == e.id))
                                                .where((element) {
                                              return searchQuery == null ||
                                                      searchQuery.isEmpty
                                                  ? true
                                                  : element.userName
                                                      .toLowerCase()
                                                      .contains(searchQuery
                                                          .toLowerCase());
                                            }).toList();
                                            return ListView.builder(
                                              controller: scrollController,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount: peopleList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                final followerModel =
                                                    peopleList[index];
                                                return Padding(
                                                  key: ValueKey(
                                                      followerModel.userId),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 8),
                                                  child: Column(
                                                    children: [
                                                      FollowerDetails(
                                                        followerModel:
                                                            followerModel,
                                                        isAdmin: widget
                                                            .followerListImpl
                                                            .isAdmin,
                                                        isBlockByAdmin:
                                                            peopleList[index]
                                                                .blockedByAdmin,
                                                        onBlockUser: () {
                                                          context
                                                              .read<
                                                                  FollowersListCubit>()
                                                              .toggleBlockUser(
                                                                id: followerModel
                                                                    .userId,
                                                                postId: widget
                                                                    .postId,
                                                                followersFrom: widget
                                                                    .followerListImpl
                                                                    .followerFrom,
                                                              );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
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
                                    ),
                                  );
                                },
                              );
                            },
                            onListType: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: logs.length + 1,
                              itemBuilder: (BuildContext context, index) {
                                if (index < logs.length) {
                                  final followerModel = logs[index];
                                  return Padding(
                                    key: ValueKey(followerModel.userId),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: Column(
                                      children: [
                                        FollowerDetails(
                                          followerModel: followerModel,
                                          isAdmin:
                                              widget.followerListImpl.isAdmin,
                                          isBlockByAdmin:
                                              followerModel.blockedByAdmin,
                                          onBlockUser: () {
                                            context
                                                .read<FollowersListCubit>()
                                                .toggleBlockUser(
                                                  id: followerModel.userId,
                                                  postId: widget.postId,
                                                  followersFrom: widget
                                                      .followerListImpl
                                                      .followerFrom,
                                                );
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        const ThemeDivider(
                                          thickness: 1,
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else {
                                  if (followerList.paginationModel.isLastPage) {
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
