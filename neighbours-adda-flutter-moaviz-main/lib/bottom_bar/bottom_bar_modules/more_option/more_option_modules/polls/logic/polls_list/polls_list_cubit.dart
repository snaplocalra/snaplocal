import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/repository/polls_list_repository.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'polls_list_state.dart';

class PollsListCubit extends Cubit<PollsListState> {
  final PollsListRepository pollsListRepository;
  PollsListCubit(this.pollsListRepository)
      : super(
          PollsListState(
              pollsTypeListModel: PollsTypeListModel(
            onGoingPolls: PollsListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            yourPolls: PollsListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            // closedPolls: PollsListModel(
            //   data: const [],
            //   paginationModel: PaginationModel.initial(),
            // ),
          )),
        );

  Future<PollsListModel> _fetchPollsByType({
    bool loadMoreData = false,
    required PollsListType pollsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    late PollsListModel pollsListModel;

    if (pollsListType == PollsListType.onGoing) {
      pollsListModel = state.pollsTypeListModel.onGoingPolls;
    } else if (pollsListType == PollsListType.yourPolls) {
      pollsListModel = state.pollsTypeListModel.yourPolls;
    }
    // else {
    //   pollsListModel = state.pollsTypeListModel.closedPolls;
    // }

    try {
      if (loadMoreData) {
        //Run the fetch fetchPolls API, if it is not the last page.
        if (!pollsListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          pollsListModel.paginationModel.currentPage += 1;
          final moreData = await pollsListRepository.fetchPolls(
            page: pollsListModel.paginationModel.currentPage,
            pollsListType: pollsListType,
            searchKeyword: searchKeyword,
            filterJson: filterJson,
          );
          return pollsListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return pollsListModel;
        }
      } else {
        return await pollsListRepository.fetchPolls(
          page: 1,
          pollsListType: pollsListType,
          searchKeyword: searchKeyword,
          filterJson: filterJson,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing Polls model
      return pollsListModel;
    }
  }

  Future<void> fetchPolls({
    bool loadMoreData = false,
    bool allowDataFetch = true,
    bool disableLoading = false,
    PollsListType? pollsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      if (allowDataFetch || state.pollsTypeListModel.isEmpty) {
        //If the pollsListType type is not null then fetch the Pollss data as per the type.
        if (pollsListType != null) {
          //Data fetch permission
          final allowOngoingPollsDataFetch = (allowDataFetch ||
                  state.pollsTypeListModel.onGoingPolls.data.isEmpty) &&
              (pollsListType == PollsListType.onGoing);

          final allowYourPollsDataFetch = (allowDataFetch ||
                  state.pollsTypeListModel.yourPolls.data.isEmpty) &&
              (pollsListType == PollsListType.yourPolls);

          // final allowClosedPollsDataFetch = (allowDataFetch ||
          //         state.pollsTypeListModel.closedPolls.data.isEmpty) &&
          //     (pollsListType == PollsListType.closedPolls);

          emit(
            state.copyWith(
              //If the loadMore is true, then don't emit the loading state
              isOngoingPollsDataLoading:
                  !disableLoading && !loadMoreData && allowOngoingPollsDataFetch
                      ? true
                      : false,
              isYourPollsDataLoading:
                  !disableLoading && !loadMoreData && allowYourPollsDataFetch
                      ? true
                      : false,

              // isClosedPollsDataLoading:
              //     !disableLoading && !loadMoreData && allowClosedPollsDataFetch
              //         ? true
              //         : false,
            ),
          );

          //If any of the data fetch permission is true then fetch the data.
          if (allowOngoingPollsDataFetch || allowYourPollsDataFetch
              // ||
              // allowClosedPollsDataFetch
              ) {
            final pollsListModelByType = await _fetchPollsByType(
              pollsListType: pollsListType,
              loadMoreData: loadMoreData,
              filterJson: filterJson,
              searchKeyword: searchKeyword,
            );
            _emitDataByType(
              pollsListType: pollsListType,
              pollsListModel: pollsListModelByType,
            );
          }
          return;
        } else {
          //If the connection type is null then fetch both the Pollss data
          if (!disableLoading && state.pollsTypeListModel.isEmpty) {
            emit(state.copyWith(
              isOngoingPollsDataLoading: true,
              isYourPollsDataLoading: true,
              isClosedPollsDataLoading: true,
            ));
          }

          // make the api call simultaneously
          final List<Future<PollsListModel>> futures = [
            _fetchPollsByType(
              pollsListType: PollsListType.onGoing,
              filterJson: filterJson,
            ),
            _fetchPollsByType(
              pollsListType: PollsListType.yourPolls,
              filterJson: filterJson,
            ),
            // _fetchPollsByType(pollsListType: PollsListType.closedPolls),
          ];

          final List<PollsListModel> results = await Future.wait(futures);

          final onGoingPollsData = results[0];
          final yourPollsData = results[1];
          // final closedPollsData = results[2];

          //Assign the data in a variable
          final pollsTypeListModel = PollsTypeListModel(
            onGoingPolls: onGoingPollsData,
            yourPolls: yourPollsData,
            // closedPolls: closedPollsData,
          );
          emit(state.copyWith(pollsTypeListModel: pollsTypeListModel));
        }
        return;
      } else {
        //Emit previous state
        emit(state.copyWith());
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.pollsTypeListModel.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePollPost({
    required int index,
    required PollsListType pollsListType,
  }) async {
    try {
      late PollsListModel pollList;
      if (pollsListType == PollsListType.onGoing) {
        state.pollsTypeListModel.onGoingPolls.data.removeAt(index);
        pollList = state.pollsTypeListModel.onGoingPolls;
      } else if (pollsListType == PollsListType.yourPolls) {
        state.pollsTypeListModel.yourPolls.data.removeAt(index);
        pollList = state.pollsTypeListModel.yourPolls;
      }

      //  else if (pollsListType == PollsListType.closedPolls) {
      //   state.pollsTypeListModel.closedPolls.data.removeAt(index);
      //   pollList = state.pollsTypeListModel.closedPolls;
      // }

      //Refresh the list
      _emitDataByType(pollsListType: pollsListType, pollsListModel: pollList);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  void _showLoadingByType(PollsListType pollsListType) {
    if (pollsListType == PollsListType.onGoing) {
      emit(state.copyWith(isOngoingPollsDataLoading: true));
    } else if (pollsListType == PollsListType.yourPolls) {
      emit(state.copyWith(isYourPollsDataLoading: true));
    } else if (pollsListType == PollsListType.closedPolls) {
      emit(state.copyWith(isClosedPollsDataLoading: true));
    }
  }

  void _emitDataByType({
    required PollsListType pollsListType,
    required PollsListModel pollsListModel,
  }) {
    if (pollsListType == PollsListType.onGoing) {
      //emit the updated OngoingPolls data in the state.
      emit(
        state.copyWith(
          pollsTypeListModel: state.pollsTypeListModel.copyWith(
            onGoingPolls: pollsListModel,
          ),
        ),
      );
    } else if (pollsListType == PollsListType.yourPolls) {
      //emit the updated YourPolls data in the state.
      emit(
        state.copyWith(
          pollsTypeListModel: state.pollsTypeListModel.copyWith(
            yourPolls: pollsListModel,
          ),
        ),
      );
      // } else if (pollsListType == PollsListType.closedPolls) {
      //   //emit the updated ClosedPolls data in the state.
      //   emit(
      //     state.copyWith(
      //       pollsTypeListModel: state.pollsTypeListModel.copyWith(
      //         closedPolls: pollsListModel,
      //       ),
      //     ),
      //   );
    } else {
      ThemeToast.errorToast("Unable to show polls data");
      return;
    }
  }

  void refreshOnPostStateChange({
    required PollPostModel updatedModel,
    required int postIndex,
    required PollsListType pollsListType,
  }) {
    _showLoadingByType(pollsListType);
    late PollsListModel pollList;
    if (pollsListType == PollsListType.onGoing) {
      state.pollsTypeListModel.onGoingPolls.data[postIndex] = updatedModel;
      pollList = state.pollsTypeListModel.onGoingPolls;
    } else if (pollsListType == PollsListType.yourPolls) {
      state.pollsTypeListModel.yourPolls.data[postIndex] = updatedModel;
      pollList = state.pollsTypeListModel.yourPolls;
    }
    // else if (pollsListType == PollsListType.closedPolls) {
    //   state.pollsTypeListModel.closedPolls.data[postIndex] = updatedModel;
    //   pollList = state.pollsTypeListModel.closedPolls;
    // }
    //Refresh the list
    _emitDataByType(pollsListType: pollsListType, pollsListModel: pollList);
    return;
  }
}
