import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/repository/page_details_repository.dart';

part 'page_details_state.dart';

class PageDetailsCubit extends Cubit<PageDetailsState> {
  final PageDetailsRepository pageDetailsRepository;
  PageDetailsCubit(
    this.pageDetailsRepository,
  ) : super(const PageDetailsState());

  Future<void> fetchPageDetails({
    required String pageId,
    bool loadMoreData = false,
    bool enableLoading = false,
  }) async {
    try {
      if (enableLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      late PageDetailsModel pageDetails;
      if (loadMoreData) {
        //Run the fetch PagePosts API, if it is not the last page.
        if (!state.pageDetailsModel!.pagePosts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.pageDetailsModel!.pagePosts.paginationModel.currentPage += 1;

          pageDetails = await pageDetailsRepository.fetchPageDetails(
            pageId: pageId,
            page: state.pageDetailsModel!.pagePosts.paginationModel.currentPage,
          );
          if (isClosed) {
            return;
          }
          //emit the updated state.
          emit(state.copyWith(
              pageDetailsModel: state.pageDetailsModel!.copyWith(
                  pagePosts:
                      state.pageDetailsModel!.pagePosts.paginationCopyWith(
            newData: pageDetails.pagePosts,
          ))));
        } else {
          if (isClosed) {
            return;
          }
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        pageDetails = await pageDetailsRepository.fetchPageDetails(
            pageId: pageId, page: 1);
        if (isClosed) {
          return;
        }
        //Emit the new state if it is the initial load request
        emit(state.copyWith(pageDetailsModel: pageDetails));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePost(int index) async {
    try {
      if (state.pageDetailsModel != null &&
          state.pageDetailsModel!.pagePosts.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.pageDetailsModel!.pagePosts.socialPostList.removeAt(index);
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

  ///Toggle the favourite page
  Future<void> toggleFavouritePage(String pageId) async {
    try {
      emit(state.copyWith(favoriteLoading: true));

      //Call the toggleFavouritePage API
      await pageDetailsRepository.toggleFavouritePage(pageId: pageId);

      //Fetch the page details again to refresh the data
      await fetchPageDetails(pageId: pageId);

      if (isClosed) {
        return;
      }
      emit(state.copyWith(favoriteLoading: false));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(favoriteLoading: false));
    }
  }
}
