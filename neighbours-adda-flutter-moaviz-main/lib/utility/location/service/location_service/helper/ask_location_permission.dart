// Ask location permission
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/helper/custom_exception.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

/// Ask location permission, return true if permission granted, false otherwise
Future<bool> askLocationPermission(BuildContext context) async {
  try {
    return await context.read<LocationServiceRepository>().checkGPSPermission();
  } catch (e) {
    if (e is LocationPermissionDeniedForeverException) {
      showLocationPermissionPermanentDeniedHandlerDialog(context);
    }
    return false;
  }
}
