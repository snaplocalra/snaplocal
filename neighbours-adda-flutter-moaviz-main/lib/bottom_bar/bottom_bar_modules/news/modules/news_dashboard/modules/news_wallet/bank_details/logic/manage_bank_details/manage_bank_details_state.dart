part of 'manage_bank_details_cubit.dart';

sealed class ManageBankDetailsState extends Equatable {
  const ManageBankDetailsState();

  @override
  List<Object> get props => [];
}

final class AddBankDetailsInitial extends ManageBankDetailsState {}

final class AddBankDetailsLoading extends ManageBankDetailsState {}

final class AddBankDetailsSuccess extends ManageBankDetailsState {}

final class AddBankDetailsFailure extends ManageBankDetailsState {
  final String message;

  const AddBankDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
