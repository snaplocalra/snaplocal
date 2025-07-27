import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/model/neighbours_view_type.dart';

part 'list_map_view_controller_state.dart';

class DataOnMapViewControllerCubit extends Cubit<DataOnMapViewControllerState> {
  DataOnMapViewControllerCubit()
      : super(const DataOnMapViewControllerState(ListMapViewType.map));

  void toggleListMapViewType() {
    final oldType = state.listMapViewType;
    final newType = oldType == ListMapViewType.list
        ? ListMapViewType.map
        : ListMapViewType.list;
    emit(state.copyWith(listMapViewType: newType));
  }


  //set the list view
  void setListView() {
    emit(state.copyWith(listMapViewType: ListMapViewType.list));
  }
}
