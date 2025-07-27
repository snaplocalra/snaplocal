import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_shimmer.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';

class PostMapRadiusPreferenceWidget extends StatelessWidget {
  final LocationType locationType;
  final PostType? postType;
  final bool disableLocateMe;
  final bool visible;
  final void Function(
    LocationAddressWithLatLng? postFeedPosition,
    FeedRadiusModel radiusPreference,
  ) onLocationRender;

  const PostMapRadiusPreferenceWidget({
    super.key,
    required this.locationType,
    required this.onLocationRender,
    this.disableLocateMe = false,
    this.postType,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationServiceControllerCubit,
        LocationServiceControllerState>(
      listener: (context, locationServiceState) async {
        if (locationServiceState is LoadingLocation) {
          context.read<ActiveButtonCubit>().changeStatus(false);
          return;
        } else if (locationServiceState is LocationFetched) {
          context.read<ActiveButtonCubit>().changeStatus(true);
          //emitting location data
          await context.read<LocationRenderCubit>().emitLocation(
                locationAddressWithLatLong: locationServiceState.location,
                locationType: locationType,
              );
          return;
        } else if (locationServiceState is LocationError) {
          if (locationServiceState.locationPermanentDenied) {
            await showLocationPermissionPermanentDeniedHandlerDialog(context);
          }
        }
      },
      child: BlocBuilder<LocationRenderCubit, LocationRenderState>(
        builder: (context, locationRenderState) {
          return BlocBuilder<RadiusSliderRenderCubit, RadiusSliderRenderState>(
            builder: (context, radiusSliderState) {
              final radiusPreference = radiusSliderState.feedRadiusModel;
              late LocationAddressWithLatLng? postFeedPosition;
              late double userSelectedRadius;

              late double maxRadius;

              if (postType == PostType.poll) {
                maxRadius = radiusPreference.maxPollVisibilityRadius;
              } else {
                maxRadius = radiusPreference.maxSearchVisibilityRadius;
              }

              if (locationType == LocationType.socialMedia) {
                postFeedPosition = locationRenderState.socialMediaLocation;
                userSelectedRadius = radiusPreference.socialMediaSearchRadius;
              } else {
                postFeedPosition = locationRenderState.marketPlaceLocation;
                userSelectedRadius = radiusPreference.marketPlaceSearchRadius;
              }

              LatLng? postFeedCoOrdinates;
              if (postFeedPosition != null) {
                postFeedCoOrdinates = LatLng(
                  postFeedPosition.latitude,
                  postFeedPosition.longitude,
                );
              }

              //Update with parent
              onLocationRender.call(postFeedPosition, radiusPreference);

              return BlocBuilder<PostVisibilityControlCubit,
                  PostVisibilityControlState>(
                builder: (context, postVisibilityControlState) {
                  return AnimatedHideWidget(
                    visible: visible &&
                        postVisibilityControlState.postVisibilityControlEnum ==
                            PostVisibilityControlEnum.public,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: postFeedCoOrdinates == null
                          ? const MapAndFeedRadiusWidgetShimmer()
                          : MapAndFeedRadiusWidget(
                              disableLocateMe: disableLocateMe,
                              headingText: Text(
                                tr(LocaleKeys.postRadiusPreference),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              maxRadius: maxRadius,
                              userSelectedRadius: userSelectedRadius,
                              currentSelectedLatLng: postFeedCoOrdinates,
                              onLocateMe: () {
                                context
                                    .read<LocationServiceControllerCubit>()
                                    .locationFetchByDeviceGPS();
                              },
                              onRadiusChanged: (value) {
                                if (locationType == LocationType.socialMedia) {
                                  context
                                      .read<RadiusSliderRenderCubit>()
                                      .emitRadius(
                                        radiusPreference.copyWith(
                                          socialMediaSearchRadius: value,
                                        ),
                                      );
                                } else {
                                  context
                                      .read<RadiusSliderRenderCubit>()
                                      .emitRadius(
                                        radiusPreference.copyWith(
                                          marketPlaceSearchRadius: value,
                                        ),
                                      );
                                }
                              },
                            ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
