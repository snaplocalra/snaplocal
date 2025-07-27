// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_map_view_controller_cubit.dart';

class DataOnMapViewControllerState extends Equatable {
  final ListMapViewType listMapViewType;
  const DataOnMapViewControllerState(this.listMapViewType);

  @override
  List<Object> get props => [listMapViewType];

  DataOnMapViewControllerState copyWith({ListMapViewType? listMapViewType}) {
    return DataOnMapViewControllerState(
        listMapViewType ?? this.listMapViewType);
  }
}
