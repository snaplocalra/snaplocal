import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'group_list_state.dart';

class GroupListCubit extends Cubit<GroupListState> {
  final GroupListRepository groupRepository;
  GroupListCubit(this.groupRepository)
      : super(
          GroupListState(
              groupTypeListModel: GroupTypeListModel(
            groupsYouJoined: GroupListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            managedByYou: GroupListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

  Future<GroupListModel> _fetchGroupByType({
    bool loadMoreData = false,
    required GroupListType groupListType,
  }) async {
    late GroupListModel groupListModel;

    if (groupListType == GroupListType.groupsYouJoined) {
      groupListModel = state.groupTypeListModel.groupsYouJoined;
    } else {
      groupListModel = state.groupTypeListModel.managedByYou;
    }
    try {
      if (loadMoreData) {
        //Run the fetch fetchGroups API, if it is not the last page.
        if (!groupListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          groupListModel.paginationModel.currentPage += 1;
          final moreData = await groupRepository.fetchGroupsByType(
            page: groupListModel.paginationModel.currentPage,
            groupListType: groupListType,
          );
          return groupListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return groupListModel;
        }
      } else {
        return await groupRepository.fetchGroupsByType(
          page: 1,
          groupListType: groupListType,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing group model
      return groupListModel;
    }
  }

  Future<void> fetchGroups({
    bool loadMoreData = false,
    bool allowDataFetch = true,
    bool disableLoading = false,
    GroupListType? groupListType,
  }) async {
    try {
      if (allowDataFetch || state.groupTypeListModel.isEmpty) {
        //If the groupListType type is not null then fetch the groups data as per the type.
        if (groupListType != null) {
          //Data fetch permission
          final allowGroupsYouJoinedDataFetch = (allowDataFetch ||
                  state.groupTypeListModel.groupsYouJoined.data.isEmpty) &&
              (groupListType == GroupListType.groupsYouJoined);

          final allowManagedByYouDataFetch = (allowDataFetch ||
                  state.groupTypeListModel.managedByYou.data.isEmpty) &&
              (groupListType == GroupListType.managedByYou);

          emit(
            state.copyWith(
              //If the loadMore is true, then don't emit the loading state
              isGroupYouJoinedDataLoading: !disableLoading &&
                      !loadMoreData &&
                      allowGroupsYouJoinedDataFetch
                  ? true
                  : false,
              isManagedByYouDataLoading:
                  !disableLoading && !loadMoreData && allowManagedByYouDataFetch
                      ? true
                      : false,
            ),
          );

          //If any of the data fetch permission is true then fetch the data.
          if (allowGroupsYouJoinedDataFetch || allowManagedByYouDataFetch) {
            final groupListModelByType = await _fetchGroupByType(
              groupListType: groupListType,
              loadMoreData: loadMoreData,
            );
            _emitDataByType(
              groupListType: groupListType,
              groupListModel: groupListModelByType,
              isDataLoadedBySearch: false,
            );
          }
          return;
        } else {
          //If the connection type is null then fetch both the groups data
          if (!disableLoading && state.groupTypeListModel.isEmpty) {
            emit(state.copyWith(
              isGroupYouJoinedDataLoading: true,
              isManagedByYouDataLoading: true,
            ));
          }

          // make the api call simultaneously
          final List<Future<GroupListModel>> futures = [
            _fetchGroupByType(groupListType: GroupListType.groupsYouJoined),
            _fetchGroupByType(groupListType: GroupListType.managedByYou),
          ];
          final List<GroupListModel> results = await Future.wait(futures);

          final groupTypeListModel = GroupTypeListModel(
            groupsYouJoined: results[0],
            managedByYou: results[1],
          );

          emit(state.copyWith(groupTypeListModel: groupTypeListModel));
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
      if (state.groupTypeListModel.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  Future<void> deleteGroupFromList({
    required int groupIndex,
    required GroupListType groupListType,
  }) async {
    try {
      GroupListModel groupListModel =
          groupListType == GroupListType.groupsYouJoined
              ? state.groupTypeListModel.groupsYouJoined
              : state.groupTypeListModel.managedByYou;

      if (groupListModel.data.isNotEmpty) {
        groupListModel.data.removeAt(groupIndex);
        _emitDataByType(
          groupListType: groupListType,
          groupListModel: groupListModel,
          isDataLoadedBySearch: false,
        );
      }

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.groupTypeListModel.isEmpty) {
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
    bool isDataLoadedBySearch = false,
    required GroupListType groupListType,
    required GroupListModel groupListModel,
  }) {
    if (groupListType == GroupListType.groupsYouJoined) {
      //emit the updated groupsYouJoined data in the state.
      emit(state.copyWith(
          groupTypeListModel: state.groupTypeListModel
              .copyWith(groupsYouJoined: groupListModel)));
    } else {
      //emit the updated managedByYou data in the state.
      emit(state.copyWith(
          groupTypeListModel: state.groupTypeListModel.copyWith(
        managedByYou: groupListModel,
      )));
    }
  }

  //refresh state
  void refreshState() {
    emit(state.copyWith(
      isGroupYouJoinedDataLoading: true,
      isManagedByYouDataLoading: true,
    ));
    emit(state.copyWith());
  }
}
