import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/models/group_connection_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';

part 'private_group_join_requests_state.dart';

class PrivateGroupJoinRequestsCubit
    extends Cubit<PrivateGroupJoinRequestsState> {
  final GroupConnectionRepository groupConnectionRepository;

  PrivateGroupJoinRequestsCubit(this.groupConnectionRepository)
      : super(const PrivateGroupJoinRequestsState());

  Future<void> fetchPrivateGroupJoinRequets({
    required String groupId,
    bool loadMoreData = false,
    bool enableLoading = false,
  }) async {
    try {
      if (enableLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      late GroupConnectionListModel groupConnectionListModel;
      if (loadMoreData) {
        //Run the fetch groupPosts API, if it is not the last page.
        if (!state.groupConnectionListModel!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.groupConnectionListModel!.paginationModel.currentPage += 1;

          groupConnectionListModel =
              await groupConnectionRepository.fetchPendingJoinRequest(
            groupId: groupId,
            page: state.groupConnectionListModel!.paginationModel.currentPage,
          );
          //emit the updated state.
          emit(state.copyWith(
              groupConnectionListModel: state.groupConnectionListModel!
                  .paginationCopyWith(newData: groupConnectionListModel)));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        groupConnectionListModel = await groupConnectionRepository
            .fetchPendingJoinRequest(groupId: groupId, page: 1);
        //Emit the new state if it is the initial load request
        emit(
            state.copyWith(groupConnectionListModel: groupConnectionListModel));
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
}
