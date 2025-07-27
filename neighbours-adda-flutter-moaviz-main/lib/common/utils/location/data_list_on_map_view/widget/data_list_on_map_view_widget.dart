import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/model/neighbours_view_type.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/render_list_data_on_map_widget.dart';

class DataListOrMapViewWidget extends StatelessWidget {
  ///Widget to show when the list view is selected
  final Widget onListType;

  ///Initial location to show on the map
  final LatLng? initialLocation;

  ///Radius to show cover area on the map
  final double coveredAreaRadius;

  ///List of cluster markers to show on the map
  final List<ClusterMarkerModel> clusterMarkerList;

  ///When user tap on the cluster marker then this function will be called
  ///with the list of cluster markers
  final void Function(List<ClusterMarkerModel>) onClustersTap;

  final String? customMarker;

  final bool enableMaxZoom;

  const DataListOrMapViewWidget({
    super.key,
    required this.initialLocation,
    required this.onListType,
    required this.clusterMarkerList,
    required this.onClustersTap,
    required this.coveredAreaRadius,
    required this.customMarker,
    this.enableMaxZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataOnMapViewControllerCubit,
        DataOnMapViewControllerState>(
      builder: (context, listMapViewControllerState) {
        final isListType =
            listMapViewControllerState.listMapViewType == ListMapViewType.list;
        if (isListType) {
          return onListType;
        } else {
          return initialLocation == null
              ? const SizedBox.shrink()
              : RenderListDataOnMapWidget(
                  enableMaxZoom: enableMaxZoom,
                  customMarker: customMarker,
                  mapLocation: initialLocation!,
                  coveredAreaRadius: coveredAreaRadius,
                  clusterMarkerModelList: clusterMarkerList,
                  onClustersTap: onClustersTap,
                );
        }
      },
    );
  }
}
