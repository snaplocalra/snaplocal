import 'dart:async';

import 'package:designer/utility/theme_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/update_profile_setting_location_and_feed_radius/update_profile_setting_location_and_feed_radius_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

class MapAndFeedRadiusWidgetByLocationType extends StatefulWidget {
  final String feedRadiusHeading;
  final String feedRadiusDescription;
  final LocationType locationType;
  final LatLng selectedCoOdrinates;

  final bool visible;
  const MapAndFeedRadiusWidgetByLocationType({
    super.key,
    required this.feedRadiusHeading,
    required this.feedRadiusDescription,
    required this.locationType,
    required this.selectedCoOdrinates,
    required this.visible,
  });

  @override
  State<MapAndFeedRadiusWidgetByLocationType> createState() =>
      _MapAndFeedRadiusWidgetByLocationTypeState();
}

class _MapAndFeedRadiusWidgetByLocationTypeState
    extends State<MapAndFeedRadiusWidgetByLocationType> {
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locationServiceControllerCubit,
      child: Visibility(
        visible: widget.visible,
        child: BlocListener<LocationServiceControllerCubit,
            LocationServiceControllerState>(
          listener: (context, locationServiceControllerState) async {
            if (locationServiceControllerState is LocationFetched) {
              context.read<LocationRenderCubit>().emitLocation(
                  locationAddressWithLatLong:
                      locationServiceControllerState.location,
                  locationType: widget.locationType);
              return;
            } else if (locationServiceControllerState is LocationError) {
              if (locationServiceControllerState.locationPermanentDenied) {
                await showLocationPermissionPermanentDeniedHandlerDialog(
                    context);
              }
            }
          },
          child: BlocBuilder<RadiusSliderRenderCubit, RadiusSliderRenderState>(
            builder: (context, radiusSliderState) {
              final feedRadiusModel = radiusSliderState.feedRadiusModel;
              final maxRadius = feedRadiusModel.maxSearchVisibilityRadius;
              return MapAndFeedRadiusWidget(
                headingText: Text(
                  tr(widget.feedRadiusHeading),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subHeadingText: Text(
                  tr(widget.feedRadiusDescription),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color.fromRGBO(139, 139, 140, 1),
                  ),
                ),
                // circleRadius: circleRadius,
                maxRadius: maxRadius,
                userSelectedRadius:
                    widget.locationType == LocationType.socialMedia
                        ? feedRadiusModel.socialMediaSearchRadius
                        : feedRadiusModel.marketPlaceSearchRadius,
                currentSelectedLatLng: widget.selectedCoOdrinates,
                onLocateMe: () {
                  context
                      .read<LocationServiceControllerCubit>()
                      .locationFetchByDeviceGPS()
                      .then((locationAddressWithLatLong) {
                    if (locationAddressWithLatLong != null) {
                      if (context.mounted) {
                        context
                            .read<
                                UpdateProfileSettingLocationAndFeedRadiusCubit>()
                            .updateLocation(
                              locationAddressWithLatLong:
                                  locationAddressWithLatLong,
                              locationType: widget.locationType,
                            );
                      }
                    }
                  });
                },
                onRadiusChanged: (value) {
                  if (timer != null && timer!.isActive) {
                    timer!.cancel();
                  }
                  if (widget.locationType == LocationType.socialMedia) {
                    context
                        .read<RadiusSliderRenderCubit>()
                        .emitRadius(feedRadiusModel.copyWith(
                          socialMediaSearchRadius: value,
                        ));
                  } else if (widget.locationType == LocationType.marketPlace) {
                    //Market place radius change
                    context
                        .read<RadiusSliderRenderCubit>()
                        .emitRadius(feedRadiusModel.copyWith(
                          marketPlaceSearchRadius: value,
                        ));
                  } else {
                    ThemeToast.errorToast("Unable to render radius");
                  }
                  timer = Timer(const Duration(seconds: 1), () {
                    // Call method here after 1 second of no activity in the radius change
                    if (mounted) {
                      context
                          .read<
                              UpdateProfileSettingLocationAndFeedRadiusCubit>()
                          .updateFeedRadius(
                            feedRadius: value,
                            fetchProfileSetting: true,
                            locationType: widget.locationType,
                          );
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
