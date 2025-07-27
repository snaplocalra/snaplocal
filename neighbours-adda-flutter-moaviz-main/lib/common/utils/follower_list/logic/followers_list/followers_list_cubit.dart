import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_list_model.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_type.dart';
import 'package:snap_local/common/utils/follower_list/repository/follower_list_repository.dart';

part 'followers_list_state.dart';

class FollowersListCubit extends Cubit<FollowersListState> {
  final FollowerListRepository followerListRepository;
  FollowersListCubit(this.followerListRepository)
      : super(const FollowersListState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> fetchFollowerList({
    bool loadMoreData = false,
    bool showSearchLoading = false,
    required String postId,
    required FollowersFrom followersFrom,
  }) async {
    // final showDataLoading =
    //     state.error != null || state.followerListNotAvailable;

    emit(state.copyWith(
      dataLoading: true,
      isSearchLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData && state.followerList != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.followerList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.followerList!.paginationModel.currentPage += 1;
          final moreData = await followerListRepository.fetchFollowerList(
            page: state.followerList!.paginationModel.currentPage,
            query: _searchQuery,
            postId: postId,
            followersFrom: followersFrom,
          );

          emit(state.copyWith(
            followerList:
                state.followerList!.paginationCopyWith(newData: moreData),
          ));
          return;
        }
        else{
          emit(state.copyWith(dataLoading: false));
        }
      }
      else {
        final followerList = await followerListRepository.fetchFollowerList(
          postId: postId,
          query: _searchQuery,
          followersFrom: followersFrom,
        );

        emit(state.copyWith(followerList: followerList));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.followerListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  Future<void> fetchInfluencerFollowerList({
    bool loadMoreData = false,
    bool showSearchLoading = false,
    required String userId,
  }) async {
    // final showDataLoading =
    //     state.error != null || state.followerListNotAvailable;

    emit(state.copyWith(
      dataLoading: true,
      isSearchLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData && state.followerList != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.followerList!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.followerList!.paginationModel.currentPage += 1;
          final moreData = await followerListRepository.fetchInfluencerFollowerList(
            page: state.followerList!.paginationModel.currentPage,
            query: _searchQuery,
            userId: userId,
          );

          emit(state.copyWith(
            followerList:
            state.followerList!.paginationCopyWith(newData: moreData),
          ));
          return;
        }
      }
      else {
        final followerList = await followerListRepository.fetchInfluencerFollowerList(
          userId: userId,
          query: _searchQuery,
        );

        emit(state.copyWith(followerList: followerList));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.followerListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }


  //block user
  Future<void> toggleBlockUser({
    required String id,
    required String postId,
    required FollowersFrom followersFrom,
  }) async {
    final user =
        state.followerList!.data.firstWhere((element) => element.userId == id);
    try {
      emit(state.copyWith(dataLoading: true));
      //update the block status
      user.blockedByAdmin = !user.blockedByAdmin;
      emit(state.copyWith());
      //update on the server
      await followerListRepository.toggleBlockUser(
        userId: user.userId,
        postId: postId,
        followersFrom: followersFrom,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
    }
  }
}
