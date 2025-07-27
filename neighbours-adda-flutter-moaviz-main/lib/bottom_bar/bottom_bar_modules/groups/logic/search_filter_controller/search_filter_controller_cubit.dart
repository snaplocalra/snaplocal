import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';

part 'search_filter_controller_state.dart';

class SearchFilterControllerCubit extends Cubit<SearchFilterControllerState> {
  final SearchFilterType searchFilterType;
  SearchFilterControllerCubit(this.searchFilterType)
      : super(SearchFilterControllerState(
          searchFilterTypeCategories: searchFilterType.data,
        ));

  //select search filter type
  void selectSearchFilterType(SearchFilterTypeEnum searchFilterTypeEnum) {
    emit(state.copyWith(dataLoading: true));
    for (var i = 0; i < state.searchFilterTypeCategories.length; i++) {
      if (state.searchFilterTypeCategories[i].type == searchFilterTypeEnum) {
        state.searchFilterTypeCategories[i].isSelected = true;
      } else {
        state.searchFilterTypeCategories[i].isSelected = false;
      }
    }
    emit(state.copyWith(dataLoading: false));
  }
}
