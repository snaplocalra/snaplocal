// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as cluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/create_cluster_marker_bit_map.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/widgets/google_map_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class RenderListDataOnMapWidget extends StatefulWidget {
  final LatLng mapLocation;
  final double coveredAreaRadius;
  final List<ClusterMarkerModel> clusterMarkerModelList;
  final void Function(List<ClusterMarkerModel> selectedClusters) onClustersTap;
  final String? customMarker;
  final bool enableMaxZoom;
  const RenderListDataOnMapWidget({
    super.key,
    required this.mapLocation,
    required this.clusterMarkerModelList,
    required this.onClustersTap,
    required this.coveredAreaRadius,

    ///This will be user for both single and multi cluster type
    required this.customMarker,
    required this.enableMaxZoom,
  });

  @override
  State<RenderListDataOnMapWidget> createState() =>
      _RenderListDataOnMapWidgetState();
}

class _RenderListDataOnMapWidgetState extends State<RenderListDataOnMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> markers = {};

  late final cluster.ClusterManager _manager = _initClusterManager();

  void _updateMarkers(Set<Marker> markers) {
    if (mounted) {
      setState(() {
        this.markers = markers;
      });
    }
  }

  cluster.ClusterManager _initClusterManager() {
    return cluster.ClusterManager<ClusterMarkerModel>(
      widget.clusterMarkerModelList,
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  Future<Marker> Function(cluster.Cluster<ClusterMarkerModel>)
      get _markerBuilder => (cluster) async {
            return Marker(
              markerId: MarkerId(cluster.getId()),
              position: cluster.location,
              onTap: () {
                widget.onClustersTap([...cluster.items]);
              },
              icon: !cluster.isMultiple && cluster.items.first.maskLocation
                  ? await createMaskCircleMarkerBitmap()
                  : widget.customMarker != null
                      ? await createMapPinBadgeMarkerBitmap(
                          imagePath: widget.customMarker!,
                          count: cluster.isMultiple ? cluster.count : null,
                        )
                      : await createMapPinMarkerBitmap(
                          imagePath: cluster.isMultiple
                              ? AssetsImages.multiMapDataBluePin
                              : AssetsImages.singleMapDataBluePin,
                          count: cluster.isMultiple ? cluster.count : null,
                        ),
            );
          };

  void initData() {
    //Animate to the location
    _mapController?.animateCamera(CameraUpdate.newLatLng(widget.mapLocation));
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void didUpdateWidget(covariant RenderListDataOnMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      initData();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleRadius = (widget.coveredAreaRadius * 1000);
    return Stack(
      children: [
        GoogleMapWidget(
          minMaxZoomPreference:
              MinMaxZoomPreference(9, widget.enableMaxZoom ? 14.5 : null),
          onMapCreated: (controller) {
            _mapController = controller;
            _manager.setMapId(controller.mapId);
          },
          setInitialMarker: true,
          location: widget.mapLocation,
          markers: markers,
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
          circleRadius: circleRadius,
          circles: {
            Circle(
              circleId: const CircleId("feed_radius"),
              center: widget.mapLocation,
              strokeWidth: 2,
              strokeColor: const Color.fromRGBO(
                241,
                170,
                170,
                1,
              ),
              fillColor: const Color.fromRGBO(
                241,
                170,
                170,
                0.2,
              ),
              radius: circleRadius,
            )
          },
        ),
      ],
    );
  }
}
