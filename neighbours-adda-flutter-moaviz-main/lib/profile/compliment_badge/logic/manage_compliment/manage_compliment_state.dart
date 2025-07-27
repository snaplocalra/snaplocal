part of 'manage_compliment_cubit.dart';

sealed class ManageComplimentState extends Equatable {
  const ManageComplimentState();

  @override
  List<Object> get props => [];
}

final class ManageComplimentInitial extends ManageComplimentState {}

final class ManageComplimentRequestLoading extends ManageComplimentState {}

final class ManageComplimentRequestSuccess extends ManageComplimentState {
  final String message;

  const ManageComplimentRequestSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ManageComplimentRequestError extends ManageComplimentState {
  final String message;

  const ManageComplimentRequestError(this.message);

  @override
  List<Object> get props => [message];
}
