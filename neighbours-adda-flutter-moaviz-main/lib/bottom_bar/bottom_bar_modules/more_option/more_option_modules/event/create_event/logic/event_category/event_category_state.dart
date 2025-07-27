part of 'event_category_cubit.dart';

class EventCategoryState extends Equatable {
  final bool dataLoading;
  final String? error;
  final CategoryListModel eventTopics;
  const EventCategoryState({
    this.dataLoading = false,
    this.error,
    required this.eventTopics,
  });

  @override
  List<Object?> get props => [eventTopics, dataLoading, error];

  EventCategoryState copyWith({
    bool? dataLoading,
    String? error,
    CategoryListModel? eventTopics,
  }) {
    return EventCategoryState(
      dataLoading: dataLoading ?? false,
      error: error,
      eventTopics: eventTopics ?? this.eventTopics,
    );
  }
}
