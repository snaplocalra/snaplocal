import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/local_notification/logic/notification_counter/notification_counter_cubit.dart';
import 'package:snap_local/common/utils/local_notification/model/local_notification_model.dart';
import 'package:snap_local/common/utils/local_notification/repository/local_notification_repository.dart';

part 'local_notification_view_state.dart';

class LocalNotificationViewCubit extends Cubit<LocalNotificationViewState> {
  final LocalNotificationRepository localNotificationRepository;
  final NotificationCounterCubit notificationCounterCubit;
  LocalNotificationViewCubit(
    this.localNotificationRepository,
    this.notificationCounterCubit,
  ) : super(LocalNotificationViewState(
            localNotificationList: LocalNotificationList.emptyModel()));

  Future<void> fetchNotifications({bool loadMoreData = false}) async {
    try {
      //Late initial for the notification model
      late LocalNotificationList localNotifications;
      if (loadMoreData) {
        //Run the fetch home feed API, if it is not the last page.
        if (!state.localNotificationList.paginationModel.isLastPage) {
          //Increase the current page counter
          state.localNotificationList.paginationModel.currentPage += 1;

          localNotifications =
              await localNotificationRepository.fetchNotifications(
            page: state.localNotificationList.paginationModel.currentPage,
          );
          await notificationCounterCubit.fetchNotificationCount();

          //emit the updated state.
          emit(state.copyWith(
              localNotificationList:
                  state.localNotificationList.paginationCopyWith(
            newData: localNotifications,
          )));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        emit(state.copyWith(dataLoading: true));
        localNotifications =
            await localNotificationRepository.fetchNotifications();
        await notificationCounterCubit.fetchNotificationCount();

        //Emit the new state if it is the initial load request
        emit(state.copyWith(localNotificationList: localNotifications));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.localNotificationList.data.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }
}
