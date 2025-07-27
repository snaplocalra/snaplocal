// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_controller_cubit.dart';

class FilterControllerState extends Equatable {
  final bool isLoading;
  final String? filter;
  const FilterControllerState({this.filter, this.isLoading = false});

  @override
  List<Object?> get props => [filter, isLoading];

  FilterControllerState copyWith({
    bool? isLoading,
    String? filter,
  }) {
    return FilterControllerState(
      isLoading: isLoading ?? false,
      filter: filter ?? this.filter,
    );
  }
}
