import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';

part 'group_home_data_state.dart';

class GroupHomeDataCubit extends Cubit<GroupHomeDataState> {
  final GroupListRepository groupRepository;

  GroupHomeDataCubit(this.groupRepository) : super(GroupHomeDataInitial());

  void fetchGroupHomeData(SearchFilterTypeEnum searchFilterType) async {
    try {
      emit(GroupHomeDataLoading());
      final data = await groupRepository.fetchGroupHomeData(
          searchFilterType: searchFilterType);
      emit(GroupHomeDataLoaded(data));
    } catch (e) {
      emit(const GroupHomeDataError('Error fetching group data'));
    }
  }
}
