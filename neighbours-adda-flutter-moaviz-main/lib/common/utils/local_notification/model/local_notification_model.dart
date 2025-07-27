import 'package:snap_local/common/utils/models/route_navigation_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

import '../../../../utility/constant/errors.dart';

class LocalNotificationModel {
  final String id;
  final String image;
  final String description;
  final String timming;
  final RouteNavigationModel? notificationTapNavigationModel;

  LocalNotificationModel({
    required this.id,
    required this.image,
    required this.description,
    required this.timming,
    this.notificationTapNavigationModel,
  });

  factory LocalNotificationModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildNotification(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildNotification(map);
    }
  }


  static LocalNotificationModel _buildNotification(Map<String, dynamic> map) {
    return LocalNotificationModel(
      id: map['id'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      timming: map['created_date'] as String,
      notificationTapNavigationModel: map['navigation_details'] != null
          ? RouteNavigationModel.fromMap(
              map['navigation_details'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LocalNotificationList {
  List<LocalNotificationModel> data;
  PaginationModel paginationModel;

  LocalNotificationList({
    required this.data,
    required this.paginationModel,
  });

  factory LocalNotificationList.emptyModel() => LocalNotificationList(
      data: [], paginationModel: PaginationModel.initial());

  factory LocalNotificationList.fromMap(Map<String, dynamic> map) {
    return LocalNotificationList(
      data: List<LocalNotificationModel>.from((map['data'])
          .map<LocalNotificationModel>((x) =>
              LocalNotificationModel.fromMap(x as Map<String, dynamic>))),
      paginationModel: PaginationModel.fromMap(map),
    );
  }

  //Use for pagination
  LocalNotificationList paginationCopyWith(
      {required LocalNotificationList newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;
    return LocalNotificationList(
      data: data,
      paginationModel: paginationModel,
    );
  }
}
