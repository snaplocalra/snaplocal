import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/local_notification/repository/local_notification_repository.dart';

part 'notification_counter_state.dart';

class NotificationCounterCubit extends Cubit<NotificationCounterState> {
  final LocalNotificationRepository localNotificationRepository;
  NotificationCounterCubit(this.localNotificationRepository)
      : super(const NotificationCounterState());

  Future<void> fetchNotificationCount() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final notificationCount =
          await localNotificationRepository.fetchNotificationCount();
      emit(state.copyWith(notificationCount: notificationCount));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
    }
  }
}
