part of 'group_home_data_cubit.dart';

sealed class GroupHomeDataState extends Equatable {
  const GroupHomeDataState();

  @override
  List<Object> get props => [];
}

final class GroupHomeDataInitial extends GroupHomeDataState {}

//Loading state
final class GroupHomeDataLoading extends GroupHomeDataState {}

//Data loaded state
final class GroupHomeDataLoaded extends GroupHomeDataState {
  final List<GroupModel> data;

  const GroupHomeDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

//Error state
final class GroupHomeDataError extends GroupHomeDataState {
  final String error;

  const GroupHomeDataError(this.error);

  @override
  List<Object> get props => [error];
}
