import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/helper/create_marker_from_asset.dart';

part 'asset_marker_creator_state.dart';

class AssetMarkerCreatorCubit extends Cubit<AssetMarkerCreatorState> {
  AssetMarkerCreatorCubit() : super(const AssetMarkerCreatorState());

  // createAssetMarker method
  Future<void> createAssetMarker({
    required LatLng selectedLocation,
    required String assetImageMapMarker,
  }) async {
    emit(state.copyWith(loading: true));
    final markers = await createMarker(
      selectedLocation: selectedLocation,
      assetImageMapMarker: assetImageMapMarker,
    );
    emit(state.copyWith(markers: markers));
  }
}
