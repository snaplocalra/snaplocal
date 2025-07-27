part of 'business_timming_cubit.dart';

class BusinessHoursState extends Equatable {
  final bool dataLoading;
  final BusinessHoursModel businessHoursModel;

  const BusinessHoursState({
    required this.businessHoursModel,
    this.dataLoading = false,
  });

  @override
  List<Object> get props => [businessHoursModel, dataLoading];

  BusinessHoursState copyWith({
    BusinessHoursModel? businessHoursModel,
    bool? dataLoading,
  }) {
    return BusinessHoursState(
      dataLoading: dataLoading ?? false,
      businessHoursModel: businessHoursModel ?? this.businessHoursModel,
    );
  }
}
