part of 'sales_post_cubit.dart';

class SalesPostState extends Equatable {
  final bool isSalesPostByNeighboursDataLoading;
  final bool isSalesPostByYouDataLoading;
  final String? error;
  final SalesPostDataModel salesPostDataModel;
  const SalesPostState({
    this.isSalesPostByNeighboursDataLoading = false,
    this.isSalesPostByYouDataLoading = false,
    required this.salesPostDataModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isSalesPostByNeighboursDataLoading,
        isSalesPostByYouDataLoading,
        salesPostDataModel,
        error
      ];

  SalesPostState copyWith({
    bool? isSalesPostByNeighboursDataLoading,
    bool? isSalesPostByYouDataLoading,
    SalesPostDataModel? salesPostDataModel,
    String? error,
  }) {
    return SalesPostState(
      isSalesPostByNeighboursDataLoading:
          isSalesPostByNeighboursDataLoading ?? false,
      isSalesPostByYouDataLoading: isSalesPostByYouDataLoading ?? false,
      salesPostDataModel: salesPostDataModel ?? this.salesPostDataModel,
      error: error,
    );
  }
}
