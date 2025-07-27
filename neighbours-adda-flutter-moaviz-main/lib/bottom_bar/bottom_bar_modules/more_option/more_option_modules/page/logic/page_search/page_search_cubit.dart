// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';

part 'page_search_state.dart';

class PageSearchCubit extends Cubit<PageSearchState> {
  final PageListRepository pageListRepository;
  PageSearchCubit({required this.pageListRepository})
      : super(const PageSearchState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> searchForPage({
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
        if (!state.pageSearchList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.pageSearchList!.paginationModel.currentPage += 1;
          final moreData = await pageListRepository.searchPages(
            query: _searchQuery,
            page: state.pageSearchList!.paginationModel.currentPage,
            filterJson: filterJson,
          );
          emit(state.copyWith(
            pageSearchList: state.pageSearchList!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await pageListRepository.searchPages(
          page: 1,
          query: _searchQuery,
          filterJson: filterJson,
        );

        emit(state.copyWith(pageSearchList: newData));
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

  void refreshPageOnFollowUnfollow() {
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith());
  }
}
