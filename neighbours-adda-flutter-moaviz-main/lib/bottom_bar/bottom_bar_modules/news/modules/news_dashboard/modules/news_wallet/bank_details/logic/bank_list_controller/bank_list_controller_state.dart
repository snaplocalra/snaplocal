part of 'bank_list_controller_cubit.dart';

class BankListControllerState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  final String? errorMessage;
  final List<BankDetailsModel> banklist;

  const BankListControllerState({
    this.requestLoading = false,
    this.requestSuccess = false,
    this.errorMessage,
    this.banklist = const [],
  });

  @override
  List<Object?> get props =>
      [requestLoading, requestSuccess, banklist, errorMessage];

  BankListControllerState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
    List<BankDetailsModel>? banklist,
    String? errorMessage,
  }) {
    return BankListControllerState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      errorMessage: errorMessage,
      banklist: banklist ?? this.banklist,
    );
  }

//Is any default bank selected
  bool get isDefaultBankSelected => banklist.any((bank) => bank.isDefault);
}
