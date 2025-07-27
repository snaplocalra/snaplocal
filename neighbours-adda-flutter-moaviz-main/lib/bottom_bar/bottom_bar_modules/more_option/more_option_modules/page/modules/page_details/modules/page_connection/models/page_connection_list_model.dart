// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class PageConnectionListModel {
  final List<PageConnectionModel> data;
  PaginationModel paginationModel;

  PageConnectionListModel({
    required this.data,
    required this.paginationModel,
  });

  factory PageConnectionListModel.fromJson(Map<String, dynamic> json) =>
      PageConnectionListModel(
        data: List<PageConnectionModel>.from(
            json["data"].map((x) => PageConnectionModel.fromJson(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  Map<String, dynamic> toJson() =>
      {"data": List<dynamic>.from(data.map((x) => x.toJson()))};

  //Use for pagination
  PageConnectionListModel paginationCopyWith(
      {required PageConnectionListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return PageConnectionListModel(
        data: data, paginationModel: paginationModel);
  }
}

class PageConnectionModel {
  final String id;
  final String pageId;
  final String status;
  final String requestedUserId;
  final String requestedUserName;
  final String requestedUserImage;
  final String? address;

  PageConnectionModel({
    required this.id,
    required this.pageId,
    required this.status,
    required this.requestedUserId,
    required this.requestedUserName,
    required this.requestedUserImage,
    this.address,
  });

  factory PageConnectionModel.fromJson(Map<String, dynamic> json) =>
      PageConnectionModel(
        id: json["id"],
        status: json["status"],
        address: json["address"],
        pageId: json["Page_id"],
        requestedUserId: json["requested_user_id"],
        requestedUserName: json["requested_user_name"],
        requestedUserImage: json["requested_user_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "address": address,
        "Page_id": pageId,
        "requested_user_id": requestedUserId,
        "requested_user_name": requestedUserName,
        "requested_user_image": requestedUserImage,
      };
}
