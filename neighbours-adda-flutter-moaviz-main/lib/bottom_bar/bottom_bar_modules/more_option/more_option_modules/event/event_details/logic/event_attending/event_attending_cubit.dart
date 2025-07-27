import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/models/event_attending_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/repository/event_attending_repository.dart';

part 'event_attending_state.dart';

class EventAttendingCubit extends Cubit<EventAttendingState> {
  final EventAttendingRepository eventAttendingRepository;
  EventAttendingCubit(this.eventAttendingRepository)
      : super(const EventAttendingState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> fetchAttendingList({
    bool loadMoreData = false,
    bool showSearchLoading = false,
    required String eventId,
  }) async {
    final showDataLoading =
        state.error != null || state.eventAttendingListNotAvailable;

    emit(state.copyWith(
      dataLoading: showDataLoading,
      isSearchLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData && state.eventAttendingList != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.eventAttendingList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.eventAttendingList!.paginationModel.currentPage += 1;
          final moreData = await eventAttendingRepository.fetchEventAttedning(
            page: state.eventAttendingList!.paginationModel.currentPage,
            query: _searchQuery,
            eventId: eventId,
          );

          emit(state.copyWith(
            eventAttendingList:
                state.eventAttendingList!.paginationCopyWith(newData: moreData),
          ));
          return;
        }
      } else {
        final eventAttendingList =
            await eventAttendingRepository.fetchEventAttedning(
          query: _searchQuery,
          eventId: eventId,
        );

        emit(state.copyWith(eventAttendingList: eventAttendingList));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.eventAttendingListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }
}
