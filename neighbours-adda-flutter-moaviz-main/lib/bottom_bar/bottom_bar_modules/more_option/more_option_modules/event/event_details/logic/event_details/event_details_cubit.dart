import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/models/event_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/repository/event_post_details_repository.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventDetailsRepository eventPostDetailsRepository;
  EventDetailsCubit(this.eventPostDetailsRepository)
      : super(const EventDetailsState());

  Future<void> fetchEventDetails(String eventId) async {
    try {
      if (state.error != null || !state.isEventPostDetailAvailable) {
        emit(state.copyWith(dataLoading: true));
      }
      final eventPostDetailsModel =
          await eventPostDetailsRepository.fetchEventDetails(eventId);
      emit(state.copyWith(eventPostDetailsModel: eventPostDetailsModel));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updatePostSaveStatus(bool newStatus) {
    if (state.eventPostDetailsModel != null) {
      emit(state.copyWith(dataLoading: true));
      emit(state.copyWith(
        eventPostDetailsModel:
            state.eventPostDetailsModel!.copyWith(isSaved: newStatus),
      ));
    }
    return;
  }

  Future<void> cancelEvent(String eventId) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await eventPostDetailsRepository.cancelEvent(eventId);
      await fetchEventDetails(eventId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> toggleAttending(String eventId) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await eventPostDetailsRepository.toggleAttending(eventId);
      await fetchEventDetails(eventId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
    }
  }
}
