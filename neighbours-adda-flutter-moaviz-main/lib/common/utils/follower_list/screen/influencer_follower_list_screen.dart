import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/follower_list/logic/followers_list/followers_list_cubit.dart';
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

class InfluencerFollowerListScreen extends StatefulWidget {
  final String userId;

  static const routeName = 'influencer_follower_list';
  const InfluencerFollowerListScreen({
    super.key,
    required this.userId,
  });

  @override
  State<InfluencerFollowerListScreen> createState() => _InfluencerFollowerListScreenState();
}

class _InfluencerFollowerListScreenState extends State<InfluencerFollowerListScreen> {
  final scrollController = ScrollController();
  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();
  late FollowersListCubit followersListCubit =
      FollowersListCubit(FollowerListRepository())
        ..fetchInfluencerFollowerList(
          userId: widget.userId,
        );

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        followersListCubit.fetchInfluencerFollowerList(
          loadMoreData: true,
          userId: widget.userId,
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
            "User Following",
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
            //widget.followerListImpl.heading(context),
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
                      context.read<FollowersListCubit>().fetchInfluencerFollowerList(
                            userId: widget.userId,
                            showSearchLoading: true,
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
                          return ListView.builder(
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
                                        isAdmin: false,
                                        isBlockByAdmin: followerModel.blockedByAdmin,
                                        // onBlockUser: () {
                                        //   context
                                        //       .read<FollowersListCubit>()
                                        //       .toggleBlockUser(
                                        //         id: followerModel.userId,
                                        //         postId: widget.userId,
                                        //         followersFrom: widget.followerListImpl.followerFrom,
                                        //       );
                                        // },
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
