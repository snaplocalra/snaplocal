// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class PollsTypeListModel {
  final PollsListModel onGoingPolls;
  final PollsListModel yourPolls;
  // final PollsListModel closedPolls;
  PollsTypeListModel({
    required this.onGoingPolls,
    required this.yourPolls,
    // required this.closedPolls,
  });
  bool get isEmpty => onGoingPolls.data.isEmpty || yourPolls.data.isEmpty;
  // ||
  // closedPolls.data.isEmpty;

  bool get isAllListEmpty =>
      onGoingPolls.data.isEmpty && yourPolls.data.isEmpty;
  // &&
  // closedPolls.data.isEmpty;

  PollsTypeListModel copyWith({
    PollsListModel? onGoingPolls,
    PollsListModel? yourPolls,
    // PollsListModel? closedPolls,
  }) {
    return PollsTypeListModel(
      onGoingPolls: onGoingPolls ?? this.onGoingPolls,
      yourPolls: yourPolls ?? this.yourPolls,
      // closedPolls: closedPolls ?? this.closedPolls,
    );
  }
}

class PollsListModel {
  final List<PollPostModel> data;
  PaginationModel paginationModel;

  PollsListModel({
    required this.data,
    required this.paginationModel,
  });

  //empty model
  factory PollsListModel.emptyModel() =>
      PollsListModel(data: [], paginationModel: PaginationModel.initial());

  //json serialization
  factory PollsListModel.fromJson(Map<String, dynamic> json) => PollsListModel(
        data: List<PollPostModel>.from(
          json["data"].map((x) => PollPostModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  PollsListModel paginationCopyWith({required PollsListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return PollsListModel(data: data, paginationModel: paginationModel);
  }
}
