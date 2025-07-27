part of 'follow_controller_cubit.dart';

sealed class FollowControllerState extends Equatable {
  const FollowControllerState();

  @override
  List<Object> get props => [];
}

final class FollowRequestInitial extends FollowControllerState {}

final class FollowRequestLoading extends FollowControllerState {}

final class FollowRequestSuccess extends FollowControllerState {}

final class FollowRequestError extends FollowControllerState {
  final String message;

  const FollowRequestError(this.message);

  @override
  List<Object> get props => [message];
}
