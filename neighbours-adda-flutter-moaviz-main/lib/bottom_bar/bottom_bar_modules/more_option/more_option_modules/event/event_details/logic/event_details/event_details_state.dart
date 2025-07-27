part of 'event_details_cubit.dart';

class EventDetailsState extends Equatable {
  final EventDetailsModel? eventPostDetailsModel;
  final String? error;
  final bool dataLoading;
  final bool requestLoading;
  const EventDetailsState({
    this.eventPostDetailsModel,
    this.error,
    this.dataLoading = false,
    this.requestLoading = false,
  });

  bool get isEventPostDetailAvailable => eventPostDetailsModel != null;

  @override
  List<Object?> get props => [
        eventPostDetailsModel,
        error,
        dataLoading,
        requestLoading,
      ];

  EventDetailsState copyWith({
    EventDetailsModel? eventPostDetailsModel,
    String? error,
    bool? dataLoading,
    bool? requestLoading,
  }) {
    return EventDetailsState(
      eventPostDetailsModel:
          eventPostDetailsModel ?? this.eventPostDetailsModel,
      error: error,
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
    );
  }
}
