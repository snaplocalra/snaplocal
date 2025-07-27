part of 'event_list_cubit.dart';

class EventListState extends Equatable {
  final bool isLocalEventDataLoading;
  final bool isManageEventDataLoading;
  final String? error;
  final EventPostDataModel eventPostDataModel;
  const EventListState({
    this.isLocalEventDataLoading = false,
    this.isManageEventDataLoading = false,
    required this.eventPostDataModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isLocalEventDataLoading,
        isManageEventDataLoading,
        eventPostDataModel,
        error
      ];

  EventListState copyWith({
    bool? isLocalEventDataLoading,
    bool? isManageEventDataLoading,
    EventPostDataModel? eventPostDataModel,
    String? error,
  }) {
    return EventListState(
      isLocalEventDataLoading: isLocalEventDataLoading ?? false,
      isManageEventDataLoading: isManageEventDataLoading ?? false,
      eventPostDataModel: eventPostDataModel ?? this.eventPostDataModel,
      error: error,
    );
  }
}
