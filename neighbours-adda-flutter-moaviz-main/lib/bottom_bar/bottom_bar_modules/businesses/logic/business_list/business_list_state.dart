// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'business_list_cubit.dart';

class BusinessListState extends Equatable {
  final bool dataLoading;
  final String? error;
  final BusinessListModel? businessListModel;
  const BusinessListState({
    this.dataLoading = false,
    this.error,
    this.businessListModel,
  });

  bool get businessListNotAvailable =>
      businessListModel == null || businessListModel!.data.isEmpty;

  @override
  List<Object?> get props => [businessListModel, error, dataLoading];

  BusinessListState copyWith({
    bool? dataLoading,
    String? error,
    BusinessListModel? businessListModel,
  }) {
    return BusinessListState(
      dataLoading: dataLoading ?? false,
      error: error,
      businessListModel: businessListModel ?? this.businessListModel,
    );
  }
}
