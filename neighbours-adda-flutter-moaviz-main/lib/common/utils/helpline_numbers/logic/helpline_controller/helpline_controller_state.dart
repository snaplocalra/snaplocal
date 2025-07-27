part of 'helpline_controller_cubit.dart';

sealed class HelplineControllerState extends Equatable {
  const HelplineControllerState();

  @override
  List<Object> get props => [];
}

final class HelplineControllerInitial extends HelplineControllerState {}

final class HelplineControllerLoading extends HelplineControllerState {}

final class HelplineControllerLoaded extends HelplineControllerState {
  final List<HelplineNumberModel> helplineNumbers;

  const HelplineControllerLoaded(this.helplineNumbers);

  @override
  List<Object> get props => [helplineNumbers];
}

final class HelplineControllerError extends HelplineControllerState {
  final String message;

  const HelplineControllerError(this.message);

  @override
  List<Object> get props => [message];
}
