// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class EventAttendingListModel {
  final List<EventAttendingModel> data;
  PaginationModel paginationModel;

  EventAttendingListModel({
    required this.data,
    required this.paginationModel,
  });

  factory EventAttendingListModel.emptyModel() =>
      EventAttendingListModel(data: [], paginationModel: PaginationModel.initial());

  factory EventAttendingListModel.fromJson(Map<String, dynamic> json) => EventAttendingListModel(
        data: List<EventAttendingModel>.from(
          json["data"].map((x) => EventAttendingModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  EventAttendingListModel paginationCopyWith({required EventAttendingListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return EventAttendingListModel(data: data, paginationModel: paginationModel);
  }
}

class EventAttendingModel {
  final String userId;
  final String userName;
  final String userImage;
  final LocationAddressWithLatLng location;
  final bool isEventHost;
  final bool isVerified;

  ///To indicate whether the current user is viewing
  final bool isViewingUser;

  EventAttendingModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.location,
    required this.isEventHost,
    required this.isVerified,
    required this.isViewingUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'user_name': userName,
      'user_image': userImage,
      'location': location.toMap(),
      'is_event_host': isEventHost,
      'is_verified': isVerified,
      'is_viewing_user': isViewingUser,
    };
  }

  factory EventAttendingModel.fromMap(Map<String, dynamic> map) {
    return EventAttendingModel(
      userId: map['user_id'],
      userName: map['user_name'],
      userImage: map['user_image'],
      location: LocationAddressWithLatLng.fromMap(map['location']),
      isEventHost: map['is_event_host'],
      isVerified: map['is_verified'],
      isViewingUser: map['is_viewing_user'],
    );
  }
}
