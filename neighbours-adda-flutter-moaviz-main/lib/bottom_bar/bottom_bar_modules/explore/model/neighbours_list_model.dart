import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

import '../../../../utility/constant/errors.dart';

class NeighboursListModel {
  final List<ProfileDetailsModel> data;
  PaginationModel paginationModel;

  NeighboursListModel({
    required this.data,
    required this.paginationModel,
  });

  factory NeighboursListModel.emptyModel() =>
      NeighboursListModel(data: [], paginationModel: PaginationModel.initial());


  factory NeighboursListModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildNeighboursList(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildNeighboursList(json);
    }
  }

  static NeighboursListModel _buildNeighboursList (Map<String, dynamic> json) =>
      NeighboursListModel(
        data: List<ProfileDetailsModel>.from(json["data"]
            .map((x) => ProfileDetailsModel.fromJson(x, isOwnProfile: false))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  NeighboursListModel paginationCopyWith(
      {required NeighboursListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return NeighboursListModel(data: data, paginationModel: paginationModel);
  }
}
