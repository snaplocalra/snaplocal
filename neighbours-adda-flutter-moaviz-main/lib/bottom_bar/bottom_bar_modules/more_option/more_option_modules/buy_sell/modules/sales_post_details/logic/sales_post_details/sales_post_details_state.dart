// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sales_post_details_cubit.dart';

class SalesPostDetailsState extends Equatable {
  final SalesPostDetailModel? salesPostDetailModel;
  final String? error;
  final bool dataLoading;
  final bool requestLoading;
  const SalesPostDetailsState({
    this.salesPostDetailModel,
    this.error,
    this.dataLoading = false,
    this.requestLoading = false,
  });

  bool get isSalesPostDetailAvailable => salesPostDetailModel != null;

  @override
  List<Object?> get props => [
        salesPostDetailModel,
        error,
        dataLoading,
        requestLoading,
      ];

  SalesPostDetailsState copyWith({
    SalesPostDetailModel? salesPostDetailModel,
    String? error,
    bool? dataLoading,
    bool? requestLoading,
  }) {
    return SalesPostDetailsState(
      salesPostDetailModel: salesPostDetailModel ?? this.salesPostDetailModel,
      error: error,
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
    );
  }
}
