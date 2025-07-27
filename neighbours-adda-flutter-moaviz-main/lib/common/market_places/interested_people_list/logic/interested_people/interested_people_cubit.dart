import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/market_places/interested_people_list/model/interested_people_model.dart';
import 'package:snap_local/common/market_places/interested_people_list/repository/interested_people_repository.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';

part 'interested_people_state.dart';

class InterestedPeopleCubit extends Cubit<InterestedPeopleState> {
  final InterestedPeopleRepository interestedPeopleRepository;
  InterestedPeopleCubit(this.interestedPeopleRepository)
      : super(const InterestedPeopleState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> fetchInterestedPeopleList({
    bool loadMoreData = false,
    bool showSearchLoading = false,
    required String postId,
    required MarketPlaceType marketPlaceType,
  }) async {
    final showDataLoading =
        state.error != null || state.interestedPeopleListNotAvailable;

    emit(state.copyWith(
      dataLoading: showDataLoading,
      isSearchLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData && state.interestedPeopleList != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.interestedPeopleList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.interestedPeopleList!.paginationModel.currentPage += 1;
          final moreData =
              await interestedPeopleRepository.fetchInterestedPeopleList(
            page: state.interestedPeopleList!.paginationModel.currentPage,
            query: _searchQuery,
            postId: postId,
            marketPlaceType: marketPlaceType,
          );

          emit(state.copyWith(
            interestedPeopleList: state.interestedPeopleList!
                .paginationCopyWith(newData: moreData),
          ));
          return;
        }
        else{
          emit(state.copyWith(dataLoading: false));
        }
      }
      else {
        final interestedPeopleList =
            await interestedPeopleRepository.fetchInterestedPeopleList(
          query: _searchQuery,
          postId: postId,
          marketPlaceType: marketPlaceType,
        );

        emit(state.copyWith(interestedPeopleList: interestedPeopleList));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.interestedPeopleListNotAvailable) {
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
