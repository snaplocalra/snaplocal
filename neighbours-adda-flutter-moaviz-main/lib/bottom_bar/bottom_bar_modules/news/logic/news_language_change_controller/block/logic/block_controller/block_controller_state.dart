part of 'block_controller_cubit.dart';

sealed class BlockControllerState extends Equatable {
  const BlockControllerState();

  @override
  List<Object> get props => [];
}

final class BlockControllerInitial extends BlockControllerState {}

final class BlockControllerLoading extends BlockControllerState {}

final class BlockControllerSuccess extends BlockControllerState {}

final class BlockControllerError extends BlockControllerState {
  final String message;

  const BlockControllerError(this.message);

  @override
  List<Object> get props => [message];
}
