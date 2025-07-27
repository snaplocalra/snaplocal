// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/repository/group_details_repository.dart';

part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final GroupDetailsRepository groupDetailsRepository;
  GroupDetailsCubit(
    this.groupDetailsRepository,
  ) : super(const GroupDetailsState());

  Future<void> fetchGroupDetails({
    required String groupId,
    bool loadMoreData = false,
    bool enableLoading = false,
  }) async {
    try {
      if (enableLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      late GroupDetailsModel groupDetails;
      if (loadMoreData) {
        //Run the fetch groupPosts API, if it is not the last page.
        if (!state.groupDetailsModel!.groupPosts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.groupDetailsModel!.groupPosts.paginationModel.currentPage += 1;

          groupDetails = await groupDetailsRepository.fetchGroupDetails(
            groupId: groupId,
            page:
                state.groupDetailsModel!.groupPosts.paginationModel.currentPage,
          );
          //emit the updated state.
          emit(state.copyWith(
            groupDetailsModel: state.groupDetailsModel!.copyWith(
              groupPosts:
                  state.groupDetailsModel!.groupPosts.paginationCopyWith(
                newData: groupDetails.groupPosts,
              ),
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        groupDetails = await groupDetailsRepository.fetchGroupDetails(
            groupId: groupId, page: 1);
        //Emit the new state if it is the initial load request
        emit(state.copyWith(groupDetailsModel: groupDetails));
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
      if (state.groupDetailsModel != null &&
          state.groupDetailsModel!.groupPosts.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.groupDetailsModel!.groupPosts.socialPostList.removeAt(index);
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

  //delete group
  Future<void> deleteGroup(String groupId) async {
    try {
      emit(state.copyWith(deleteLoading: true));
      await groupDetailsRepository.deleteGroup(groupId: groupId);
      emit(state.copyWith(deleteSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }

  //block group
  Future<void> toggleBlockGroup(String groupId) async {
    try {
      emit(state.copyWith(toggleBlockLoading: true));
      await groupDetailsRepository.toggleBlockGroup(groupId: groupId);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(toggleBlockSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }

  //toggle favorite group
  Future<void> toggleFavoriteGroup(String groupId) async {
    try {
      emit(state.copyWith(favoriteLoading: true));
      await groupDetailsRepository.toggleFavoriteGroup(groupId: groupId);
      await fetchGroupDetails(groupId: groupId);
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
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(favoriteLoading: false));
    }
  }
}
