import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/screen/category_wise_feed_posts_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/widgets/event_short_details_list_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_with_map_view_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/map_view_data_list_bottom_sheet.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';

/// This widget displays a map view with clustered markers and a list view of social media posts.
/// It allows users to view social media posts on a map and interact with them by tapping on the markers.
/// The widget also provides a bottom sheet that displays a list of posts related to the selected markers.
class SocialMediaMapListViewWidget extends StatelessWidget {
  final Widget child;
  final LatLng? initialLocation;
  final double coveredAreaRadius;
  final String? customMarker;
  final List<SocialPostModel> socialPosts;
  final Future<void> Function() onRefresh;

  /// Constructs a [SocialMediaMapListViewWidget].
  ///
  /// The [child] parameter is the widget to be displayed when the list view is active.
  /// The [initialLocation] parameter is the initial location to center the map view.
  /// The [coveredAreaRadius] parameter is the radius of the area covered by the map view.
  /// The [customMarker] parameter is the custom marker icon to be used for the markers.
  /// The [socialPosts] parameter is the list of social media posts to be displayed on the map.
  const SocialMediaMapListViewWidget({
    super.key,
    required this.child,
    required this.initialLocation,
    required this.coveredAreaRadius,
    required this.customMarker,
    required this.socialPosts,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return DataListWithMapViewWidget(
      customMarker: customMarker,
      onRefresh: onRefresh,
      initialLocation: initialLocation,
      coveredAreaRadius: coveredAreaRadius,
      clusterMarkerList: socialPosts
          .map(
            (e) => ClusterMarkerModel(
              id: e.id,
              latlng: LatLng(
                e.postLocation.latitude,
                e.postLocation.longitude,
              ),
            ),
          )
          .toList(),
      onClustersTap: (selectedMarkers) {
        // Show a bottom sheet with the list of neighbours in horizontal
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          builder: (context) => MapViewDataListBottomSheet(
            markersCount: selectedMarkers.length,
            builder: (context, searchQuery) {
              final postsOnMap = selectedMarkers
                  .map((e) =>
                      socialPosts.firstWhere((element) => element.id == e.id))
                  //search filter
                  .where((element) => element.searchKeyword(searchQuery))
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: postsOnMap.length,
                itemBuilder: (context, index) {
                  final postDetails = postsOnMap[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child:
                        // Event post type
                        postDetails.postType == PostType.event
                            ? MultiBlocProvider(
                                key: ValueKey(postDetails.id),
                                providers: [
                                  BlocProvider(
                                    create: (_) =>
                                        PostActionCubit(PostActionRepository()),
                                  ),
                                  BlocProvider(
                                    create: (_) => PostDetailsControllerCubit(
                                      socialPostModel: postDetails,
                                    ),
                                  ),
                                ],
                                child: const EventShortDetailsListWidget(),
                              )
                            :
                            // Only for "safety" and "lost and found" categories
                            CategoryWisePostViewOnMapData(
                                postDetails: postDetails),
                  );
                },
              );
            },
          ),
        );
      },
      onListType: child,
    );
  }
}
