import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';

part 'location_render_state.dart';

class LocationRenderCubit extends Cubit<LocationRenderState> {
  LocationRenderCubit() : super(const LocationRenderState());

  Future<void> emitLocation({
    required LocationAddressWithLatLng? locationAddressWithLatLong,
    required LocationType locationType,
  }) async {
    emit(state.copyWith(isDataLoaded: false));
    if (locationType == LocationType.socialMedia) {
      emit(state.copyWith(
        socialMediaLocation: locationAddressWithLatLong,
        isDataLoaded: true,
      ));
    } else if (locationType == LocationType.marketPlace) {
      emit(state.copyWith(
        marketPlaceLocation: locationAddressWithLatLong,
        isDataLoaded: true,
      ));
    } else {
      ThemeToast.errorToast("Unable to render location");
      return;
    }
  }

  Future<void> emitBothLocationType({
    required LocationAddressWithLatLng? socialMediaLocation,
    required LocationAddressWithLatLng? marketPlaceLocation,
  }) async {
    emit(state.copyWith(
      socialMediaLocation: socialMediaLocation,
      marketPlaceLocation: marketPlaceLocation,
      isDataLoaded: true,
    ));
  }
}
