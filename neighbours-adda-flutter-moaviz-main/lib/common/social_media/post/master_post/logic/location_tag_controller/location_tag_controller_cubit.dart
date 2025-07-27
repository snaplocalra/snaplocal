// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

part 'location_tag_controller_state.dart';

class LocationTagControllerCubit extends Cubit<LocationTagControllerState> {
  final LocationAddressWithLatLng? taggedLocation;
  LocationTagControllerCubit({this.taggedLocation})
      : super(LocationTagControllerState(taggedLocation: taggedLocation));

  void addLocationTag(LocationAddressWithLatLng taggedLocation) {
    emit(state.copyWith(taggedLocation: taggedLocation));
  }

  void removeLocationTag() {
    emit(state.copyWith());
  }
}
