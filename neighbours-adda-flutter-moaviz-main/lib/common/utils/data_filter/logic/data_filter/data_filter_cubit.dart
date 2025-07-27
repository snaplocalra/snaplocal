import 'dart:convert';
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

part 'data_filter_state.dart';

class DataFilterCubit extends Cubit<DataFilterState> {
  final List<DataFilter> dataFilter;
  DataFilterCubit(this.dataFilter)
      : super(DataFilterState(dataFilter: dataFilter));

  //Show filter
  void toggleShowFilter() {
    emit(state.copyWith(showFilter: !state.showFilter));
  }

  void showFilter(bool showFilter) {
    emit(state.copyWith(showFilter: showFilter));
  }

  //Apply filter
  void applyFilter() {
    emit(state.copyWith(filterApplied: true));
  }

  //Insert or update filter
  void insertOrUpdateFilter(DataFilter filter) {
    try {
      emit(state.copyWith(isLoading: true));
      bool isFilterFound = false;
      for (var i = 0; i < dataFilter.length; i++) {
        if (dataFilter[i].id == filter.id) {
          dataFilter[i] = filter;
          isFilterFound = true;
          break;
        }
      }

      if (!isFilterFound) {
        dataFilter.add(filter);
      }

      //Emit the update data filter as new copy
      emit(state.copyWith(dataFilter: List.from(dataFilter)));
    } catch (e) {
      ThemeToast.errorToast(e.toString());
    }
  }

  //Update filter
  void updateFilter({
    int? filterIndex,
    String? filterId,
    required DataFilterStrategy strategy,
  }) {
    try {
      //if both filterIndex and filterType is null then throw error
      if (filterIndex == null && filterId == null) {
        throw 'Filter index or filter type is required';
      }

      //If filterIndex is null then get the filter index from the filter id
      final filterPosition = filterIndex ??
          dataFilter.indexWhere((element) => element.id == filterId);

      // Get the sort filter from the data filter
      DataFilter filter = dataFilter[filterPosition];

      //update the sort filter data
      dataFilter[filterPosition] = filter.setFilter(strategy);

      //Emit the update data filter as new copy
      emit(state.copyWith(dataFilter: List.from(dataFilter)));
    } catch (e) {
      ThemeToast.errorToast(e.toString());
    }
  }

  //Clear all the filters
  void clearAllFilters() {
    try {
      emit(state.copyWith(isLoading: true));

      //Clear all the filters
      for (var i = 0; i < dataFilter.length; i++) {
        //Clear the filter and reassign the filter in the list
        dataFilter[i] = dataFilter[i].clearFilter();
      }

      //Emit the update data filter as new copy
      emit(state.copyWith(
        dataFilter: List.from(dataFilter),
        filterApplied: true,
      ));
    } catch (e) {
      ThemeToast.errorToast(e.toString());
    }
  }
}
