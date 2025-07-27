part of 'page_home_data_cubit.dart';

sealed class PageHomeDataState extends Equatable {
  const PageHomeDataState();

  @override
  List<Object> get props => [];
}

final class PageHomeDataInitial extends PageHomeDataState {}

//Loading state
final class PageHomeDataLoading extends PageHomeDataState {}

//Data loaded state
final class PageHomeDataLoaded extends PageHomeDataState {
  final List<PageModel> data;

  const PageHomeDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

//Error state
final class PageHomeDataError extends PageHomeDataState {
  final String error;

  const PageHomeDataError(this.error);

  @override
  List<Object> get props => [error];
}
