// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'business_details_cubit.dart';

class BusinessDetailsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final BusinessDetailsModel? businessDetailsModel;
  const BusinessDetailsState({
    this.dataLoading = false,
    this.businessDetailsModel,
    this.error,
  });

  bool get isBusinessViewDetailsAvailable => businessDetailsModel != null;

  @override
  List<Object?> get props => [dataLoading, businessDetailsModel, error];

  BusinessDetailsState copyWith({
    bool? dataLoading,
    String? error,
    BusinessDetailsModel? businessDetailsModel,
  }) {
    return BusinessDetailsState(
      dataLoading: dataLoading ?? false,
      error: error,
      businessDetailsModel: businessDetailsModel ?? this.businessDetailsModel,
    );
  }
}
