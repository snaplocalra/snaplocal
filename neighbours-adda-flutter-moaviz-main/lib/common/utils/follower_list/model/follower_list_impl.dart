import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_type.dart';

abstract class FollowerListImpl {
  String get title;
  bool get isAdmin;
  LatLng get latLng;
  double get searchRadius;
  Widget heading(BuildContext context);
  FollowersFrom get followerFrom;
}
