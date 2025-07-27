part of 'local_notification_view_cubit.dart';

class LocalNotificationViewState extends Equatable {
  final String? error;
  final bool dataLoading;
  final LocalNotificationList localNotificationList;
  const LocalNotificationViewState({
    this.error,
    this.dataLoading = false,
    required this.localNotificationList,
  });

  @override
  List<Object?> get props => [error, dataLoading, localNotificationList];

  LocalNotificationViewState copyWith({
    String? error,
    bool? dataLoading,
    LocalNotificationList? localNotificationList,
  }) {
    return LocalNotificationViewState(
      error: error,
      dataLoading: dataLoading ?? false,
      localNotificationList:
          localNotificationList ?? this.localNotificationList,
    );
  }
}
