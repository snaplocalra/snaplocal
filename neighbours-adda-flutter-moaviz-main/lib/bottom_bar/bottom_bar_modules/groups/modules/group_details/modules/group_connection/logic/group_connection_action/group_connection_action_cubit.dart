import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';

part 'group_connection_action_state.dart';

class GroupConnectionActionCubit extends Cubit<GroupConnectionActionState> {
  final GroupConnectionRepository groupConnectionRepository;
  final GroupListCubit groupListCubit;
  final int? groupIndex;
  GroupConnectionActionCubit({
    required this.groupConnectionRepository,
    required this.groupListCubit,
    this.groupIndex,
  }) : super(const GroupConnectionActionState());

  Future<bool> removeGroupFromParentList() async {
    if (groupIndex != null) {
      //remove the group from the parent groupsYouJoined list
      await groupListCubit.deleteGroupFromList(
        groupIndex: groupIndex!,

        //For this time, user can exit from the group that they joined.
        groupListType: GroupListType.groupsYouJoined,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> refreshParentGroupList() async {
    //On join the group, refresh the list of the groupsYouJoined
    await groupListCubit.fetchGroups(
      disableLoading: true,
      groupListType: GroupListType.groupsYouJoined,
    );
  }

  Future<void> stopLoading() async {
    try {
      emit(state.copyWith(stopAllLoading: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  //Group admin controls
  Future<void> acceptConnection(String connectionId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isAcceptConnectionLoading: true));
      await groupConnectionRepository.acceptJoinRequest(
          connectionId: connectionId);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  Future<void> rejectJoinRequest(String connectionId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isRejectConnectionLoading: true));
      await groupConnectionRepository.rejectJoinRequest(
          connectionId: connectionId);
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  //Group user controls
  Future<void> sendAndCancelGroupJoinRequest(String groupId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isSendAndRemoveGroupJoinRequestLoading: true));
      await groupConnectionRepository.sendAndRemoveGroupJoinRequest(
          groupId: groupId);
      await refreshParentGroupList();
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }

  Future<void> exitGroupJoinRequest(String groupId) async {
    try {
      emit(state.copyWith(stopAllLoading: true));
      emit(state.copyWith(isExitGroupRequestLoading: true));
      await groupConnectionRepository.leaveGroup(groupId: groupId);
      final isSuccess = await removeGroupFromParentList();
      if (!isSuccess) {
        await refreshParentGroupList();
      }
      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(stopAllLoading: true));
    }
  }
}
