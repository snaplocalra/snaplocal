// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/helper/calculate_zoom_from_radius.dart';
import 'package:snap_local/common/utils/location/logic/asset_marker_creator/asset_marker_creator_cubit.dart';
import 'package:snap_local/common/utils/location/widgets/google_map_widget.dart';
import 'package:snap_local/common/utils/location/widgets/locate_me_button.dart';
import 'package:snap_local/common/utils/location/widgets/radius_slider.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';

class MapAndFeedRadiusWidget extends StatefulWidget {
  final double maxRadius;
  final double userSelectedRadius;
  final LatLng currentSelectedLatLng;
  final void Function(double) onRadiusChanged;
  final void Function() onLocateMe;
  final Text headingText;
  final Text? subHeadingText;
  final double zoom;
  final bool disableLocateMe;
  final bool disableRadiusSlider;

  const MapAndFeedRadiusWidget({
    super.key,
    required this.maxRadius,
    required this.userSelectedRadius,
    required this.currentSelectedLatLng,
    required this.onRadiusChanged,
    required this.onLocateMe,
    required this.headingText,
    this.subHeadingText,
    this.zoom = 12,
    this.disableLocateMe = true,
    this.disableRadiusSlider = false,
  });

  @override
  State<MapAndFeedRadiusWidget> createState() => _MapAndFeedRadiusWidgetState();
}

class _MapAndFeedRadiusWidgetState extends State<MapAndFeedRadiusWidget> {
  @override
  Widget build(BuildContext context) {
    final circleRadius = (widget.userSelectedRadius.toDouble() * 1000);
    final mqSize = MediaQuery.sizeOf(context);
    return BlocBuilder<LocationServiceControllerCubit,
        LocationServiceControllerState>(
      builder: (context, locationServiceControllerState) {
        return Container(
          padding: EdgeInsets.only(bottom: widget.disableRadiusSlider ? 0 : 15),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: mqSize.height * 0.2,
                    child: Stack(
                      children: [
                        MapWithMarker(
                          circleRadius: circleRadius,
                          preSelectedLatLng: widget.currentSelectedLatLng,
                        ),
                        Visibility(
                          visible: locationServiceControllerState ==
                              LoadingLocation(),
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                            child: const ThemeSpinner(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !widget.disableLocateMe,
                    child: Positioned(
                      right: 8,
                      bottom: 8,
                      child: LocateMeButton(
                        backgroundColor: Colors.white,
                        onLocateMe:
                            locationServiceControllerState != LoadingLocation()
                                ? widget.onLocateMe
                                : null,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !widget.disableRadiusSlider,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.headingText,
                      if (widget.subHeadingText != null) widget.subHeadingText!,
                      RadiusSlider(
                        maxRadius: widget.maxRadius,
                        onRadiusChanged: widget.onRadiusChanged,
                        userSelectedRadius: widget.userSelectedRadius,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MapWithMarker extends StatefulWidget {
  final LatLng preSelectedLatLng;
  final double circleRadius;
  final String mapMarkerImage;
  final bool hideMarker;
  const MapWithMarker({
    super.key,
    required this.preSelectedLatLng,
    required this.circleRadius,
    this.hideMarker = false,
    this.mapMarkerImage = AssetsImages.mapGreenMarker,
  });

  @override
  State<MapWithMarker> createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<MapWithMarker>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final assetMarkerCreatorCubit = AssetMarkerCreatorCubit();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    initMap();
  }

  @override
  void didUpdateWidget(covariant MapWithMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      initMap();
    }
  }

  Future<void> initMap() async {
    if (!widget.hideMarker) {
      await assetMarkerCreatorCubit.createAssetMarker(
        selectedLocation: widget.preSelectedLatLng,
        assetImageMapMarker: widget.mapMarkerImage,
      );
    }

    //Animate the camera to the selected location
    //with the radius of the circle to zoom the map
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        widget.preSelectedLatLng,
        calculateZoomLevel(widget.circleRadius),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AssetMarkerCreatorCubit, AssetMarkerCreatorState>(
      bloc: assetMarkerCreatorCubit,
      builder: (context, assetMarkerCreatorState) {
        return GoogleMapWidget(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          setInitialMarker: true,
          markers: assetMarkerCreatorState.markers,
          zoom: 1,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
          zoomGesturesEnabled: false,
          circleRadius: widget.circleRadius,
          circles: {
            Circle(
              circleId: const CircleId("feed_radius"),
              center: widget.preSelectedLatLng,
              strokeWidth: 2,
              strokeColor: const Color.fromRGBO(
                6,
                39,
                255,
                0.13,
              ),
              fillColor: const Color.fromRGBO(
                6,
                39,
                255,
                0.13,
              ),
              radius: widget.circleRadius,
            )
          },
          location: widget.preSelectedLatLng,
        );
      },
    );
  }
}
