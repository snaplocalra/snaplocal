import 'dart:convert';

import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/repository/sales_post_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'sales_post_state.dart';

class SalesPostCubit extends Cubit<SalesPostState> {
  final SalesPostRepository salesPostRepository;
  SalesPostCubit(this.salesPostRepository)
      : super(
          SalesPostState(
              salesPostDataModel: SalesPostDataModel(
            salesPostByNeighbours: SalesPostListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            salesPostByYou: SalesPostListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

  Future<SalesPostListModel> _fetchSalesPostByType({
    bool loadMoreData = false,
    required SalesPostListType salesPostListType,
    required String? filterJson,
    required String? searchKeyword,
  }) async {
    print('HELLO 0 Fetch Sales Post By Type: ${jsonEncode(filterJson)}');
    late SalesPostListModel salesPostListModel;

    if (salesPostListType == SalesPostListType.marketLocally) {
      salesPostListModel = state.salesPostDataModel.salesPostByNeighbours;
    } else {
      salesPostListModel = state.salesPostDataModel.salesPostByYou;
    }
    try {
      if (loadMoreData) {
        //Run the fetch conenction API, if it is not the last page.
        if (!salesPostListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          salesPostListModel.paginationModel.currentPage += 1;
          late SalesPostListModel moreData;
          if (salesPostListType == SalesPostListType.marketLocally) {
            moreData =
                await salesPostRepository.fetchNeighboursPostedSalesPosts(
              filterJson: filterJson,
              searchKeyword: searchKeyword,
              page: salesPostListModel.paginationModel.currentPage,
              salesPostListType: salesPostListType,
            );
          } else {
            moreData = await salesPostRepository.fetchOwnPostedSalesPosts(
              page: salesPostListModel.paginationModel.currentPage,
              salesPostListType: salesPostListType,
              filterJson: filterJson,
              searchKeyword: searchKeyword,
            );
          }
          return salesPostListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return salesPostListModel;
        }
      } else {
        late SalesPostListModel moreData;
        print('HELLO: ${jsonEncode(filterJson)}');        
        if (salesPostListType == SalesPostListType.marketLocally) {
          moreData = await salesPostRepository.fetchNeighboursPostedSalesPosts(
            page: 1,
            salesPostListType: salesPostListType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
        } else {
          moreData = await salesPostRepository.fetchOwnPostedSalesPosts(
            page: 1,
            salesPostListType: salesPostListType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
        }
        return moreData;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing connection model
      return salesPostListModel;
    }
  }

  Future<void> fetchSalesPost({
    bool loadMoreData = false,
    bool disableLoading = false,
    SalesPostListType? salesPostListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      //If the salesPostList Type is not null then fetch the salesPostList data as per the type.
      if (salesPostListType != null) {
        //Data fetch permission
        final allowSalesPostByNeighboursDataFetch =
            salesPostListType == SalesPostListType.marketLocally;

        final allowSalesPostByYouDataFetch =
            salesPostListType == SalesPostListType.myListing;

        emit(
          state.copyWith(
            //If the loadMore is true, then don't emit the loading state
            isSalesPostByNeighboursDataLoading: !disableLoading &&
                    !loadMoreData &&
                    allowSalesPostByNeighboursDataFetch
                ? true
                : false,
            isSalesPostByYouDataLoading:
                !disableLoading && !loadMoreData && allowSalesPostByYouDataFetch
                    ? true
                    : false,
          ),
        );

        //If any of the data fetch permission is true then fetch the data.
        if (allowSalesPostByNeighboursDataFetch ||
            allowSalesPostByYouDataFetch) {
          final salesPostListModelByType = await _fetchSalesPostByType(
            salesPostListType: salesPostListType,
            loadMoreData: loadMoreData,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
          _emitDataByType(
            salesPostListType: salesPostListType,
            salesPostListModel: salesPostListModelByType,
          );
        }
        return;
      } else {
        print('Hello -1: ${jsonEncode(filterJson)}');
        //If the salesPostListType type is null then fetch only own posted the sales post data
        if (!disableLoading && state.salesPostDataModel.isEmpty) {
          emit(state.copyWith(
            isSalesPostByNeighboursDataLoading: true,
            isSalesPostByYouDataLoading: true,
          ));
        }

        //Parrallel fetch the data
        final futures = [
          _fetchSalesPostByType(
            salesPostListType: SalesPostListType.marketLocally,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          ),
          _fetchSalesPostByType(
            salesPostListType: SalesPostListType.myListing,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          ),
        ];

        final results = await Future.wait(futures);

        //Assign the data in a variable
        final salesPostDataModel = SalesPostDataModel(
          salesPostByNeighbours: results[0],
          salesPostByYou: results[1],
        );

        //emit the updated data in the state.
        emit(state.copyWith(salesPostDataModel: salesPostDataModel));
      }

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.salesPostDataModel.isEmpty) {
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
    required SalesPostListType salesPostListType,
    required SalesPostListModel salesPostListModel,
  }) {
    if (salesPostListType == SalesPostListType.marketLocally) {
      //emit the updated groupsYouJoined data in the state.
      emit(state.copyWith(
        salesPostDataModel: state.salesPostDataModel
            .copyWith(salesPostByNeighbours: salesPostListModel),
      ));
    } else {
      //emit the updated managedByYou data in the state.
      emit(state.copyWith(
        salesPostDataModel: state.salesPostDataModel
            .copyWith(salesPostByYou: salesPostListModel),
      ));
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePost(int index) async {
    try {
      if (state.salesPostDataModel.salesPostByYou.data.isNotEmpty) {
        emit(state.copyWith(isSalesPostByYouDataLoading: true));
        state.salesPostDataModel.salesPostByYou.data.removeAt(index);
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
