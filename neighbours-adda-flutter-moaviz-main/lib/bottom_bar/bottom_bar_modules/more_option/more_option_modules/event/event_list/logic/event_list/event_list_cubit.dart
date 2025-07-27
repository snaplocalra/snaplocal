import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/repository/event_post_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'event_list_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final EventPostRepository eventPostRepository;
  EventListCubit(this.eventPostRepository)
      : super(
          EventListState(
              eventPostDataModel: EventPostDataModel(
            localEvents: EventPostListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            myEvents: EventPostListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

  Future<EventPostListModel> _fetchEventPostByType({
    bool loadMoreData = false,
    required EventPostListType eventPostListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    late EventPostListModel eventPostListModel;

    if (eventPostListType == EventPostListType.localEvents) {
      eventPostListModel = state.eventPostDataModel.localEvents;
    } else {
      eventPostListModel = state.eventPostDataModel.myEvents;
    }
    try {
      if (loadMoreData) {
        //Run the fetch conenction API, if it is not the last page.
        if (!eventPostListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          eventPostListModel.paginationModel.currentPage += 1;

          final moreData = await eventPostRepository.fetchEventPosts(
            page: eventPostListModel.paginationModel.currentPage,
            eventPostListType: eventPostListType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );

          return eventPostListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return eventPostListModel;
        }
      } else {
        final initialData = await eventPostRepository.fetchEventPosts(
          page: 1,
          eventPostListType: eventPostListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
        return initialData;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing connection model
      return eventPostListModel;
    }
  }

  Future<void> fetchEvents({
    bool loadMoreData = false,
    bool disableLoading = false,
    EventPostListType? eventPostListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      //If the salesPostList Type is not null then fetch the salesPostList data as per the type.
      if (eventPostListType != null) {
        //Data fetch permission
        final allowLocalEventsDataFetch =
            eventPostListType == EventPostListType.localEvents;

        final allowMyEventsDataFetch =
            eventPostListType == EventPostListType.myEvents;

        emit(
          state.copyWith(
            //If the loadMore is true, then don't emit the loading state
            isLocalEventDataLoading:
                !disableLoading && !loadMoreData && allowLocalEventsDataFetch
                    ? true
                    : false,
            isManageEventDataLoading:
                !disableLoading && !loadMoreData && allowMyEventsDataFetch
                    ? true
                    : false,
          ),
        );

        //If any of the data fetch permission is true then fetch the data.
        if (allowLocalEventsDataFetch || allowMyEventsDataFetch) {
          final eventPostListByType = await _fetchEventPostByType(
            eventPostListType: eventPostListType,
            loadMoreData: loadMoreData,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
          _emitDataByType(
            eventPostListType: eventPostListType,
            eventPostListModel: eventPostListByType,
          );
        }
        return;
      } else {
        //If the eventPostListType type is null then fetch only own posted the sales post data
        if (!disableLoading && state.eventPostDataModel.isEmpty) {
          emit(state.copyWith(
            isLocalEventDataLoading: true,
            isManageEventDataLoading: true,
          ));
        }

        // make the api call simultaneously
        final List<Future<EventPostListModel>> eventFutures = [
          _fetchEventPostByType(
            eventPostListType: EventPostListType.localEvents,
          ),
          _fetchEventPostByType(eventPostListType: EventPostListType.myEvents),
        ];
        final eventPostResults = await Future.wait(eventFutures);

        //Assign the data in a variable
        final eventPostDataModel = EventPostDataModel(
          localEvents: eventPostResults[0],
          myEvents: eventPostResults[1],
        );
        emit(state.copyWith(eventPostDataModel: eventPostDataModel));
      }

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.eventPostDataModel.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  void _emitDataByType({
    required EventPostListType eventPostListType,
    required EventPostListModel eventPostListModel,
  }) {
    if (eventPostListType == EventPostListType.localEvents) {
      //emit the updated groupsYouJoined data in the state.
      emit(state.copyWith(
        eventPostDataModel:
            state.eventPostDataModel.copyWith(localEvents: eventPostListModel),
      ));
    } else {
      //emit the updated managedByYou data in the state.
      emit(state.copyWith(
        eventPostDataModel:
            state.eventPostDataModel.copyWith(myEvents: eventPostListModel),
      ));
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePost(int index) async {
    try {
      if (state.eventPostDataModel.myEvents.data.isNotEmpty) {
        emit(state.copyWith(isManageEventDataLoading: true));
        state.eventPostDataModel.myEvents.data.removeAt(index);
        emit(state.copyWith());
      } else {
        throw ("No data available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }
}
