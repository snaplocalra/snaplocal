import 'package:flutter/material.dart';
import 'package:snap_local/utility/helper/permanent_permission_denied_dialog.dart';

Future<void> showLocationPermissionPermanentDeniedHandlerDialog(
        BuildContext context) async =>
    await showPermanentPermissionDeniedHandlerDialog(
      context,
      message:
          'Location permission has been permanently denied. Please open the settings to grant the necessary permission.',
    );
