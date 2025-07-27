// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';

part 'group_search_state.dart';

class GroupSearchCubit extends Cubit<GroupSearchState> {
  final GroupListRepository groupListRepository;
  GroupSearchCubit({required this.groupListRepository})
      : super(const GroupSearchState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> searchForGroup({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    String? filterJson,
  }) async {
    final showDataLoading =
        state.error != null || !disableLoading && !loadMoreData;
    emit(state.copyWith(
      dataLoading: showDataLoading,
      isSearchDataLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData) {
        //Run the search group API, if it is not the last page.
        if (!state.groupSearchList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.groupSearchList!.paginationModel.currentPage += 1;
          final moreData = await groupListRepository.searchGroups(
            query: _searchQuery,
            page: state.groupSearchList!.paginationModel.currentPage,
            filterJson: filterJson,
          );
          emit(state.copyWith(
            groupSearchList: state.groupSearchList!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await groupListRepository.searchGroups(
          query: _searchQuery,
          page: 1,
          filterJson: filterJson,
        );

        emit(state.copyWith(groupSearchList: newData));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }

  void emitEmptyData() {
    emit(state.copyWith(groupSearchList: GroupListModel.emptyModel()));
  }

  //refresh state
  void refreshState() {
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith());
  }
}
