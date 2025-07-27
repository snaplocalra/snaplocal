// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/helper/calculate_zoom_from_radius.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng location;
  final void Function()? onCameraIdle;
  final bool setInitialMarker;
  final bool mapGesturesControl;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final Set<Circle> circles;
  final double? circleRadius;
  final double zoom;
  final bool staticZoom;
  final void Function(CameraPosition)? onCameraMove;
  final void Function(GoogleMapController)? onMapCreated;
  final void Function()? onCameraMoveStarted;
  final bool mapToolbarEnabled;
  final MinMaxZoomPreference minMaxZoomPreference;
  final Set<Marker> markers;

  const GoogleMapWidget({
    super.key,
    required this.location,
    this.onCameraIdle,
    this.setInitialMarker = false,
    this.mapGesturesControl = true,
    this.zoomControlsEnabled = false,
    this.zoomGesturesEnabled = true,
    this.zoom = 12,
    this.circleRadius,
    this.staticZoom = false,
    this.markers = const {},
    this.circles = const <Circle>{},
    this.onCameraMove,
    this.onMapCreated,
    this.onCameraMoveStarted,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.mapToolbarEnabled = false,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Set<Marker> markers = <Marker>{};

  Future<void> assignMarkers() async {
    markers = widget.markers;
  }

  void initMapSetting() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //tasks after widget tree render
      if (widget.setInitialMarker) {
        assignMarkers();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initMapSetting();
  }

  @override
  void didUpdateWidget(covariant GoogleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      initMapSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      minMaxZoomPreference: widget.minMaxZoomPreference,
      onMapCreated: widget.onMapCreated,
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onCameraMove: widget.onCameraMove,
      onCameraIdle: widget.onCameraIdle,
      circles: widget.circles,
      scrollGesturesEnabled: widget.mapGesturesControl,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.location.latitude,
          widget.location.longitude,
        ),
        zoom: widget.staticZoom
            ? widget.zoom
            : widget.circleRadius != null
                ? calculateZoomLevel(widget.circleRadius!)
                : widget.zoom, //zoom
      ),
      markers: markers,
      mapToolbarEnabled: widget.mapToolbarEnabled,
    );
  }
}
