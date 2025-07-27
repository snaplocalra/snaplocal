import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'page_list_state.dart';

class PageListCubit extends Cubit<PageListState> {
  final PageListRepository pageListRepository;
  PageListCubit(this.pageListRepository)
      : super(
          PageListState(
              pageTypeListModel: PageTypeListModel(
            pagesYouFollow: PageListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            managedByYou: PageListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

  Future<PageListModel> _fetchPageByType({
    bool loadMoreData = false,
    required PageListType pageListType,
  }) async {
    late PageListModel pageListModel;

    if (pageListType == PageListType.pagesYouFollow) {
      pageListModel = state.pageTypeListModel.pagesYouFollow;
    } else {
      pageListModel = state.pageTypeListModel.managedByYou;
    }
    try {
      if (loadMoreData) {
        //Run the fetch conenction API, if it is not the last page.
        if (!pageListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          pageListModel.paginationModel.currentPage += 1;
          final moreData = await pageListRepository.fetchPages(
            page: pageListModel.paginationModel.currentPage,
            pageListType: pageListType,
          );
          return pageListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return pageListModel;
        }
      } else {
        return await pageListRepository.fetchPages(
          page: 1,
          pageListType: pageListType,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing connection model
      return pageListModel;
    }
  }

  Future<void> fetchPages({
    bool loadMoreData = false,
    bool allowDataFetch = true,
    bool disableLoading = false,
    PageListType? pageListType,
  }) async {
    try {
      if (allowDataFetch || state.pageTypeListModel.isEmpty) {
        //If the connection type is not null then fetch the connection data as per the type.
        if (pageListType != null) {
          //Data fetch permission
          final allowPagesYouJoinedDataFetch = (allowDataFetch ||
                  state.pageTypeListModel.pagesYouFollow.data.isEmpty) &&
              (pageListType == PageListType.pagesYouFollow);

          final allowManagedByYouDataFetch = (allowDataFetch ||
                  state.pageTypeListModel.managedByYou.data.isEmpty) &&
              (pageListType == PageListType.managedByYou);

          emit(
            state.copyWith(
              //If the loadMore is true, then don't emit the loading state
              isPagesYouFollowDataLoading: !disableLoading &&
                      !loadMoreData &&
                      allowPagesYouJoinedDataFetch
                  ? true
                  : false,
              isManagedByYouDataLoading:
                  !disableLoading && !loadMoreData && allowManagedByYouDataFetch
                      ? true
                      : false,
            ),
          );

          //If any of the data fetch permission is true then fetch the data.
          if (allowPagesYouJoinedDataFetch || allowManagedByYouDataFetch) {
            final pageListModelByType = await _fetchPageByType(
              pageListType: pageListType,
              loadMoreData: loadMoreData,
            );
            _emitDataByType(
              pageListType: pageListType,
              pageListModel: pageListModelByType,
              isDataLoadedBySearch: false,
            );
          }
          return;
        } else {
          //If the connection type is null then fetch both the connection data
          if (!disableLoading && state.pageTypeListModel.isEmpty) {
            emit(state.copyWith(
              isPagesYouFollowDataLoading: true,
              isManagedByYouDataLoading: true,
            ));
          }

          // make the api call simultaneously
          final List<Future<PageListModel>> pageFutures = [
            _fetchPageByType(pageListType: PageListType.pagesYouFollow),
            _fetchPageByType(pageListType: PageListType.managedByYou),
          ];
          final List<PageListModel> pageResults =
              await Future.wait(pageFutures);

          final pageTypeListModel = PageTypeListModel(
            pagesYouFollow: pageResults[0],
            managedByYou: pageResults[1],
          );

          emit(state.copyWith(pageTypeListModel: pageTypeListModel));
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
      if (state.pageTypeListModel.isEmpty) {
        emit(state.copyWith(
          error: e.toString(),
        ));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  void _emitDataByType({
    bool isDataLoadedBySearch = false,
    required PageListType pageListType,
    required PageListModel pageListModel,
  }) {
    if (pageListType == PageListType.pagesYouFollow) {
      //emit the updated PagesYouJoined data in the state.
      emit(state.copyWith(
          pageTypeListModel: state.pageTypeListModel.copyWith(
        pagesYouFollow: pageListModel,
      )));
    } else {
      //emit the updated managedByYou data in the state.
      emit(state.copyWith(
          pageTypeListModel: state.pageTypeListModel.copyWith(
        managedByYou: pageListModel,
      )));
    }
  }

  void refreshState() {
    emit(state.copyWith(
      isManagedByYouDataLoading: true,
      isPagesYouFollowDataLoading: true,
    ));
    emit(state.copyWith());
  }
}
