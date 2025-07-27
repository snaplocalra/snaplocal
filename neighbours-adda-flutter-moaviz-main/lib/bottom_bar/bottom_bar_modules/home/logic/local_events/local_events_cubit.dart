import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_events/local_events_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_event_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalEventsCubit extends Cubit<LocalEventsState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;

  LocalEventsCubit(this.homeDataRepository)
      : super(
          const LocalEventsState(
            dataLoading: true,
            events: [],
          ),
        );

  String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('EEE, dd MMM').format(date);
  }

  String _formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('h:mma').format(time);
  }

  String getFormattedEventDateTime(LocalEventModel event) {
    final startDate = _formatDateTime(event.eventDetails.startDate);
    final endDate = _formatDateTime(event.eventDetails.endDate);
    final startTime = _formatTime(event.eventDetails.startTime);
    final endTime = _formatTime(event.eventDetails.endTime);
    
    if (startDate == endDate) {
      return '$startDate $startTime - $endTime';
    } else {
      return '$startDate $startTime - $endDate $endTime';
    }
  }

  Future<void> fetchLocalEvents() async {
    try {
      if (state.events.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final eventsResponse = await homeDataRepository.fetchLocalEvents();
      emit(state.copyWith(
        events: eventsResponse.data,
        dataLoading: false,
      ));
      return;
    } catch (e) {
      print(e.toString());
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.events.isEmpty) {
        emit(state.copyWith(
          error: e.toString(),
          dataLoading: false,
        ));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  void onSeeAllTapped() {
    // TODO: Implement see all events navigation
  }

  @override
  LocalEventsState? fromJson(Map<String, dynamic> json) {
    return LocalEventsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalEventsState state) {
    return state.toMap();
  }
} 