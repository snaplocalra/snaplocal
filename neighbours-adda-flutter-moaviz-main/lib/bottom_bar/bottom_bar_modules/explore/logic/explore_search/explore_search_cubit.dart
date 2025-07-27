import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_list/business_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/neighbours_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/repository/home_search_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/logic/sales_post/sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/jobs/jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';

part 'explore_search_state.dart';

class ExploreSearchCubit extends Cubit<ExploreState> {
  final GroupListRepository groupListRepository;
  final PageListRepository pageListRepository;
  final ExploreRepository homeSearchRepository;

  //find locally
  final BusinessListCubit businessListCubit;
  final SalesPostCubit salesPostCubit;
  final JobsCubit jobsCubit;

  ExploreSearchCubit({
    required this.groupListRepository,
    required this.pageListRepository,
    required this.homeSearchRepository,
    required this.businessListCubit,
    required this.salesPostCubit,
    required this.jobsCubit,
  }) : super(const ExploreState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  //Group search
  Future<void> searchForGroup({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
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

  //Page search
  Future<void> searchForPage({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
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
          query: _searchQuery,
          page: 1,
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

  //Neighbours search
  Future<void> searchForNeighbours({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
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
        if (!state.neighboursSearchList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.neighboursSearchList!.paginationModel.currentPage += 1;
          final moreData = await homeSearchRepository.searchNeighbours(
            query: _searchQuery,
            page: state.neighboursSearchList!.paginationModel.currentPage,
          );
          emit(state.copyWith(
            neighboursSearchList:
                state.neighboursSearchList!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await homeSearchRepository.searchNeighbours(
          query: _searchQuery,
          page: 1,
        );

        emit(state.copyWith(neighboursSearchList: newData));
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

  //Home feed search
  Future<void> searchForSocialPosts({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    PostType? postType,
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
        if (!state.feedPostsSearchList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.feedPostsSearchList!.paginationModel.currentPage += 1;
          final moreData = await homeSearchRepository.searchPosts(
            query: _searchQuery,
            page: state.feedPostsSearchList!.paginationModel.currentPage,
            postType: postType,
            filterJson: filterJson,
          );
          emit(state.copyWith(
            feedPostsSearchList: state.feedPostsSearchList!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await homeSearchRepository.searchPosts(
          page: 1,
          query: _searchQuery,
          postType: postType,
          filterJson: filterJson,
        );

        emit(state.copyWith(feedPostsSearchList: newData));
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

  //Connection Post feed search
  Future<void> searchForConnectionPosts({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    PostType? postType,
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
        if (!state.connectionPostsSearchList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.connectionPostsSearchList!.paginationModel.currentPage += 1;
          final moreData = await homeSearchRepository.searchConnectionPosts(
            query: _searchQuery,
            page: state.connectionPostsSearchList!.paginationModel.currentPage,
            filterJson: filterJson,
          );
          emit(state.copyWith(
            connectionPostsSearchList: state.connectionPostsSearchList!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await homeSearchRepository.searchConnectionPosts(
          page: 1,
          query: _searchQuery,
          filterJson: filterJson,
        );

        emit(state.copyWith(connectionPostsSearchList: newData));
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

//business search
  Future<void> searchForBusiness({
    bool showSearchLoading = false,
    String? filterJson,
  }) async {
    emit(state.copyWith(isSearchDataLoading: showSearchLoading));
    //fetch all business data
    await businessListCubit.fetchBusiness(
      businessViewType: BusinessViewType.business,
      filterJson: filterJson,
      searchKeyword: _searchQuery,
    );
    emit(state.copyWith(isSearchDataLoading: false));
  }

  //sales post search
  Future<void> searchForSalesPost({
    bool showSearchLoading = false,
    String? filterJson,
  }) async {
    emit(state.copyWith(isSearchDataLoading: showSearchLoading));
    await salesPostCubit.fetchSalesPost(
      searchKeyword: _searchQuery,
      filterJson: filterJson,
      salesPostListType: SalesPostListType.marketLocally,
    );
    emit(state.copyWith(isSearchDataLoading: false));
  }

  //jobs search
  Future<void> searchForJobs({
    bool showSearchLoading = false,
    String? filterJson,
  }) async {
    emit(state.copyWith(isSearchDataLoading: showSearchLoading));
    await jobsCubit.fetchJobs(
      searchKeyword: _searchQuery,
      filterJson: filterJson,
      jobsListType: JobsListType.byNeighbours,
    );
    emit(state.copyWith(isSearchDataLoading: false));
  }

  void refreshState() {
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith());
  }
}
