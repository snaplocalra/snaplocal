import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/see_all_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_groups/home_local_groups_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_group_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class LocalGroupsSection extends StatefulWidget {
  const LocalGroupsSection({super.key});

  @override
  State<LocalGroupsSection> createState() => _LocalGroupsSectionState();
}

class _LocalGroupsSectionState extends State<LocalGroupsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch local groups when widget initializes
    context.read<HomeLocalGroupsCubit>().fetchHomeLocalGroups();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeLocalGroupsCubit, HomeLocalGroupsState>(
      builder: (context, state) {
        // Return empty widget if there are no groups or if there's an error
        if (state.error != null || state.localGroups.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.dataLoading)
                    ShimmerWidget(
                      width: 150,
                      height: 20,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  else
                    const Text(
                      'Local Groups Near You',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E), // Deep blue color
                      ),
                    ),
                  if (state.dataLoading)
                    ShimmerWidget(
                      width: 60,
                      height: 20,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  else
                    SeeAllButton(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          GroupScreen.routeName,
                          extra: GroupListType.groupsYouJoined,
                        );
                        // GoRouter.of(context).pushNamed(
                        //   GroupScreen.routeName,
                        //   extra: GroupListType.groupsYouJoined,
                        // );
                        // context.read<SearchFilterControllerCubit>().selectSearchFilterType(SearchFilterTypeEnum.suggested);
                        //  Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => SeeAllAscreen(
                        //               groupListType: GroupListType.groupsYouJoined,
                        //               // isFromMapView: true,
                        //             ),
                        //           ));
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: state.dataLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Show 5 shimmer items while loading
                      itemBuilder: (context, index) {
                        return Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 12),
                          child: ShimmerWidget(
                            width: 110,
                            height: 120,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.localGroups.length,
                      itemBuilder: (context, index) {
                        final group = state.localGroups[index];
                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              GroupDetailsScreen.routeName,
                              queryParameters: {'id': group.groupId.toString()},
                              extra: null,
                            );
                          },
                          child: Container(
                            width: 110,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(group.groupImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                // Badge with followers count
                                // Positioned(
                                //   top: 8,
                                //   right: 8,
                                //   child: Container(
                                //     width: 24,
                                //     height: 24,
                                //     decoration: BoxDecoration(
                                //       color: Colors.pink[400],
                                //       shape: BoxShape.circle,
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         group.followersCount.toString(),
                                //         style: const TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 14,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Bottom text content
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        group.groupName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${group.followersCount} Members',
                                        style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.8),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
