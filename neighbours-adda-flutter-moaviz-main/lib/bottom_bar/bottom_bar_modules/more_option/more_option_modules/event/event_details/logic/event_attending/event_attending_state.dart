part of 'event_attending_cubit.dart';

class EventAttendingState extends Equatable {
  final bool dataLoading;
  final bool isSearchLoading;
  final String? error;
  final EventAttendingListModel? eventAttendingList;

  const EventAttendingState({
    this.dataLoading = false,
    this.isSearchLoading = false,
    this.error,
    this.eventAttendingList,
  });

  bool get eventAttendingListNotAvailable =>
      eventAttendingList == null || eventAttendingList!.data.isEmpty;

  @override
  List<Object?> get props => [
        dataLoading,
        isSearchLoading,
        error,
        eventAttendingList,
      ];

  EventAttendingState copyWith({
    bool? dataLoading,
    bool? isSearchLoading,
    String? error,
    EventAttendingListModel? eventAttendingList,
  }) {
    return EventAttendingState(
      dataLoading: dataLoading ?? false,
      isSearchLoading: isSearchLoading ?? false,
      error: error,
      eventAttendingList: eventAttendingList ?? this.eventAttendingList,
    );
  }
}
