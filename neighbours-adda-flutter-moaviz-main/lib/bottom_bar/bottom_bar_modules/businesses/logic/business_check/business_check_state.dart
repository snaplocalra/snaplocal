part of 'business_check_cubit.dart';

class BusinessCheckState extends Equatable {
  final bool dataLoading;
  final String? error;
  final BusinessDetailsModel? businessDetailsModel;
  const BusinessCheckState({
    this.dataLoading = false,
    this.businessDetailsModel,
    this.error,
  });

  bool get isBusinessDetailsAvailable => businessDetailsModel != null;

  @override
  List<Object?> get props => [dataLoading, businessDetailsModel, error];

  BusinessCheckState copyWith({
    bool? dataLoading,
    String? error,
    BusinessDetailsModel? businessDetailsModel,
  }) {
    return BusinessCheckState(
      dataLoading: dataLoading ?? false,
      error: error,
      businessDetailsModel: businessDetailsModel ?? this.businessDetailsModel,
    );
  }
}
