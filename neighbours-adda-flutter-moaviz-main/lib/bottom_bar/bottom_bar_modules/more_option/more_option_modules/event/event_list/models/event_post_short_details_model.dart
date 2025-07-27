import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class EventPostDataModel {
  final EventPostListModel localEvents;
  final EventPostListModel myEvents;
  EventPostDataModel({
    required this.localEvents,
    required this.myEvents,
  });

  bool get isEmpty => localEvents.data.isEmpty || myEvents.data.isEmpty;
  bool get isBothListEmpty => localEvents.data.isEmpty && myEvents.data.isEmpty;

  EventPostDataModel copyWith({
    EventPostListModel? localEvents,
    EventPostListModel? myEvents,
  }) {
    return EventPostDataModel(
      localEvents: localEvents ?? this.localEvents,
      myEvents: myEvents ?? this.myEvents,
    );
  }
}

class EventPostListModel {
  final List<EventPostModel> data;
  PaginationModel paginationModel;

  EventPostListModel({
    required this.data,
    required this.paginationModel,
  });

  factory EventPostListModel.emptyModel() =>
      EventPostListModel(data: [], paginationModel: PaginationModel.initial());

  factory EventPostListModel.fromJson(Map<String, dynamic> json) =>
      EventPostListModel(
        data: List<EventPostModel>.from(
          json["data"].map((x) => EventPostModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  EventPostListModel paginationCopyWith({required EventPostListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return EventPostListModel(data: data, paginationModel: paginationModel);
  }
}
