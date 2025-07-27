part of 'extract_owner_activity_data_from_link_cubit.dart';

class ExtractOwnerActivityDataFromLinkState extends Equatable {
  final bool dataLoading;
  final OwnerActivityDetailsScreenData? ownerActivityScreenData;
  final String? error;
  const ExtractOwnerActivityDataFromLinkState({
    this.dataLoading = false,
    this.ownerActivityScreenData,
    this.error,
  });

  @override
  List<Object?> get props => [dataLoading, ownerActivityScreenData, error];

  ExtractOwnerActivityDataFromLinkState copyWith({
    bool? dataLoading,
    OwnerActivityDetailsScreenData? ownerActivityScreenData,
    String? error,
  }) {
    return ExtractOwnerActivityDataFromLinkState(
      dataLoading: dataLoading ?? false,
      ownerActivityScreenData: ownerActivityScreenData,
      error: error,
    );
  }
}
