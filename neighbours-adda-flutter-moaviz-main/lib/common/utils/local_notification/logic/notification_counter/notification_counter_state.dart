part of 'notification_counter_cubit.dart';

class NotificationCounterState extends Equatable {
  final bool dataLoading;
  final int notificationCount;
  const NotificationCounterState({
    this.dataLoading = false,
    this.notificationCount = 0,
  });

  @override
  List<Object> get props => [notificationCount, dataLoading];

  NotificationCounterState copyWith({
    bool? dataLoading,
    int? notificationCount,
  }) {
    return NotificationCounterState(
      dataLoading: dataLoading ?? false,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}
