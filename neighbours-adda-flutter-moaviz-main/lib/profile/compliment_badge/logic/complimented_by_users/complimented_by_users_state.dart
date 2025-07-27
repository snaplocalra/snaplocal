part of 'complimented_by_users_cubit.dart';

sealed class ComplimentedByUsersState extends Equatable {
  const ComplimentedByUsersState();

  @override
  List<Object> get props => [];
}

final class ComplimentedByUsersInitial extends ComplimentedByUsersState {}

final class LoadingComplimentedByUsers extends ComplimentedByUsersState {}

final class ComplimentedByUsersLoaded extends ComplimentedByUsersState {
  final List<ComplimentedUserModel> users;

  const ComplimentedByUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class ComplimentedByUsersError extends ComplimentedByUsersState {
  final String message;

  const ComplimentedByUsersError(this.message);

  @override
  List<Object> get props => [message];
}
