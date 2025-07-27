part of 'news_dashboard_news_list_cubit.dart';

sealed class NewsDashboardNewsListState extends Equatable {
  const NewsDashboardNewsListState();

  @override
  List<Object> get props => [];
}

final class NewsDashboardNewsListInitial extends NewsDashboardNewsListState {}

final class NewsDashboardNewsListLoading extends NewsDashboardNewsListState {}

final class NewsDashboardNewsListLoaded extends NewsDashboardNewsListState {
  final NewsDashboardNewsListModel newsDashboardNewsListModel;
  const NewsDashboardNewsListLoaded(this.newsDashboardNewsListModel);
  @override
  List<Object> get props => [newsDashboardNewsListModel];
}

final class NewsDashboardNewsListLoadFailed extends NewsDashboardNewsListState {
  final String errorMessage;

  const NewsDashboardNewsListLoadFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
