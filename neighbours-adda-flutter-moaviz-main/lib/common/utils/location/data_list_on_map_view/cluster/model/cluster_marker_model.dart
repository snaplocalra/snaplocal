import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterMarkerModel with ClusterItem {
  final String id;
  final LatLng latlng;
  final bool maskLocation;

  ClusterMarkerModel({
    required this.id,
    required this.latlng,
    this.maskLocation = false,
  });

  @override
  LatLng get location => latlng;
}
