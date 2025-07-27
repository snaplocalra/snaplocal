import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_event_model.dart';

class LocalEventsState extends Equatable {
  final bool dataLoading;
  final List<LocalEventModel> events;
  final String? error;

  const LocalEventsState({
    required this.dataLoading,
    required this.events,
    this.error,
  });

  LocalEventsState copyWith({
    bool? dataLoading,
    List<LocalEventModel>? events,
    String? error,
  }) {
    return LocalEventsState(
      dataLoading: dataLoading ?? this.dataLoading,
      events: events ?? this.events,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'events': events.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory LocalEventsState.fromMap(Map<String, dynamic> map) {
    return LocalEventsState(
      dataLoading: map['dataLoading'] ?? false,
      events: List<LocalEventModel>.from(
        (map['events'] ?? []).map((x) => LocalEventModel.fromMap(x)),
      ),
      error: map['error'],
    );
  }

  @override
  List<Object?> get props => [dataLoading, events, error];
} 