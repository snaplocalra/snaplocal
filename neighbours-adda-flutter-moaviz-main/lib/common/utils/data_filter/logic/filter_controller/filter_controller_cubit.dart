import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_controller_state.dart';

class FilterControllerCubit extends Cubit<FilterControllerState> {
  FilterControllerCubit() : super(const FilterControllerState());

  void setFilter(String filter) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(filter: filter));
  }

  void clearFilter() {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(filter: null));
  }
}
