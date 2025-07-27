import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class WinnersListModel {
  final List<WinnerDetailsModel> data;
  PaginationModel paginationModel;

  WinnersListModel({
    required this.data,
    required this.paginationModel,
  });

  factory WinnersListModel.emptyModel() =>
      WinnersListModel(data: [], paginationModel: PaginationModel.initial());
  factory WinnersListModel.fromJson(Map<String, dynamic> json) =>
      WinnersListModel(
        data: List<WinnerDetailsModel>.from(
            json["data"].map((x) => WinnerDetailsModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  WinnersListModel paginationCopyWith({required WinnersListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return WinnersListModel(data: data, paginationModel: paginationModel);
  }
}

class WinnerDetailsModel {
  final String id;
  final String image;
  final String name;
  final String address;
  final bool isOwner;
  final List<CategoryModel> topics;

  WinnerDetailsModel({
    required this.id,
    required this.image,
    required this.name,
    required this.address,
    required this.isOwner,
    required this.topics,
  });

  factory WinnerDetailsModel.fromMap(Map<String, dynamic> map) {
    return WinnerDetailsModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      address: map['address'],
      isOwner: map['is_owner'],
      topics: List<CategoryModel>.from(
        map['interest_topics'].map<CategoryModel>(
            (x) => CategoryModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }
}
