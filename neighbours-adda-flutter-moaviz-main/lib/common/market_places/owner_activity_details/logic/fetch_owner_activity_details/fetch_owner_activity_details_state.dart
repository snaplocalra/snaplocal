// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fetch_owner_activity_details_cubit.dart';

class FetchOwnerActivityDetailsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final OwnerActivityDetailsModel? ownerActivityDetailsModel;

  const FetchOwnerActivityDetailsState({
    this.dataLoading = false,
    this.error,
    this.ownerActivityDetailsModel,
  });

  @override
  List<Object?> get props => [dataLoading, error, ownerActivityDetailsModel];

  FetchOwnerActivityDetailsState copyWith({
    bool? dataLoading,
    String? error,
    OwnerActivityDetailsModel? ownerActivityDetailsModel,
  }) {
    return FetchOwnerActivityDetailsState(
      dataLoading: dataLoading ?? false,
      error: error,
      ownerActivityDetailsModel: ownerActivityDetailsModel ?? this.ownerActivityDetailsModel,
    );
  }
}
