import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/short_business_details_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class BusinessListModel {
  final List<ShortBusinessDetailsModel> data;
  PaginationModel paginationModel;

  BusinessListModel({
    required this.data,
    required this.paginationModel,
  });

  factory BusinessListModel.emptyModel() =>
      BusinessListModel(data: [], paginationModel: PaginationModel.initial());
  factory BusinessListModel.fromJson(Map<String, dynamic> json) =>
      BusinessListModel(
        data: List<ShortBusinessDetailsModel>.from(
            json["data"].map((x) => ShortBusinessDetailsModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  BusinessListModel paginationCopyWith({required BusinessListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;
    return BusinessListModel(data: data, paginationModel: paginationModel);
  }
}
