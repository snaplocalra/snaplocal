import 'dart:convert';

import 'package:snap_local/common/utils/models/route_navigation_model.dart';

class PushNotificationDataPayload {
  final RouteNavigationModel? notificationTapNavigationModel;

  PushNotificationDataPayload({this.notificationTapNavigationModel});

  factory PushNotificationDataPayload.fromMap(Map<String, dynamic> map) {
    final jsonBody = map['navigation_details'] == null
        ? null
        : jsonDecode(map['navigation_details']);

    if (jsonBody != null) {
      return PushNotificationDataPayload(
        notificationTapNavigationModel: RouteNavigationModel.fromMap(jsonBody),
      );
    } else {
      return PushNotificationDataPayload(notificationTapNavigationModel: null);
    }
  }
}
