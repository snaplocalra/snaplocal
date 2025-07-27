import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/cluster/model/cluster_marker_model.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/render_list_data_on_map_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class DataListWithMapViewWidget extends StatelessWidget {
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

  final Future<void> Function() onRefresh;

  final ScrollController? controller;

  const DataListWithMapViewWidget({
    super.key,
    required this.initialLocation,
    required this.onListType,
    required this.clusterMarkerList,
    required this.onClustersTap,
    required this.coveredAreaRadius,
    required this.customMarker,
    this.enableMaxZoom = false,
    required this.onRefresh,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          initialLocation == null
              ? const SizedBox.shrink()
              : SizedBox(
                  height: size.height * 0.25,
                  child: Stack(
                    children: [
                      DataMapViewV2(
                        enableMaxZoom: enableMaxZoom,
                        customMarker: customMarker,
                        initialLocation: initialLocation,
                        coveredAreaRadius: coveredAreaRadius,
                        clusterMarkerList: clusterMarkerList,
                        onClustersTap: onClustersTap,
                      ),

                      //Expand button
                      Positioned(
                        right: 18,
                        bottom: 18,
                        child: ThemeElevatedButton(
                          height: 30,
                          width: 110,
                          prefix: const Icon(Icons.search, size: 18),
                          padding: EdgeInsets.zero,
                          textFontSize: 10,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog.fullscreen(
                                  child: Column(
                                    //Start from left
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Back button
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: IOSBackButton(
                                            enableBackground: false,
                                            iconSize: 20,
                                          ),
                                        ),
                                      ),

                                      //Map view
                                      Expanded(
                                        child: DataMapViewV2(
                                          enableMaxZoom: enableMaxZoom,
                                          customMarker: customMarker,
                                          initialLocation: initialLocation,
                                          coveredAreaRadius: coveredAreaRadius,
                                          clusterMarkerList: clusterMarkerList,
                                          onClustersTap: onClustersTap,
                                        ),
                                      ),

                                      //Close button
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ThemeElevatedButton(
                                            padding: EdgeInsets.zero,
                                            textFontSize: 12,
                                            height: 35,
                                            width: 120,
                                            buttonName: tr(LocaleKeys.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          buttonName: 'View Map',
                        ),
                      ),
                    ],
                  ),
                ),

          // Child widget
          onListType,
        ],
      ),
    );
  }
}

class DataMapViewV2 extends StatelessWidget {
  const DataMapViewV2({
    super.key,
    required this.enableMaxZoom,
    required this.customMarker,
    required this.initialLocation,
    required this.coveredAreaRadius,
    required this.clusterMarkerList,
    required this.onClustersTap,
  });

  final bool enableMaxZoom;
  final String? customMarker;
  final LatLng? initialLocation;
  final double coveredAreaRadius;
  final List<ClusterMarkerModel> clusterMarkerList;
  final void Function(List<ClusterMarkerModel> p1) onClustersTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: RenderListDataOnMapWidget(
          enableMaxZoom: enableMaxZoom,
          customMarker: customMarker,
          mapLocation: initialLocation!,
          coveredAreaRadius: coveredAreaRadius,
          clusterMarkerModelList: clusterMarkerList,
          onClustersTap: onClustersTap,
        ),
      ),
    );
  }
}
