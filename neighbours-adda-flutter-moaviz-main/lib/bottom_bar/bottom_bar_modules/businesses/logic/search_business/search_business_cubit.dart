import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/repository/business_list_repository.dart';

part 'search_business_state.dart';

class SearchBusinessCubit extends Cubit<SearchBusinessState> {
  final BusinessListRepository businessListRepository;

  SearchBusinessCubit(this.businessListRepository)
      : super(const SearchBusinessState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> searchBusiness({
    bool loadMoreData = false,
    required String businessCategoryId,
    bool disableLoading = false,
    bool showSearchLoading = false,
    required BusinessViewType businessViewType,
  }) async {
    final showDataLoading =
        state.error != null || !disableLoading && !loadMoreData;
    emit(state.copyWith(
      dataLoading: showDataLoading,
      isSearchLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData && state.availableBusinessList != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.availableBusinessList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.availableBusinessList!.paginationModel.currentPage += 1;
          final moreData = await businessListRepository.searchBusiness(
            page: state.availableBusinessList!.paginationModel.currentPage,
            query: _searchQuery,
            businessViewType: businessViewType,
            businessCategoryId: businessCategoryId,
          );

          emit(
            state.copyWith(
              availableBusinessList: state.availableBusinessList!
                  .paginationCopyWith(newData: moreData),
            ),
          );
          return;
        }
      } else {
        final businessList = await businessListRepository.searchBusiness(
          query: _searchQuery,
          businessViewType: businessViewType,
          businessCategoryId: businessCategoryId,
        );

        emit(state.copyWith(availableBusinessList: businessList));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.businessListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  void emitEmptyData() {
    emit(state.copyWith(availableBusinessList: BusinessListModel.emptyModel()));
  }
}
