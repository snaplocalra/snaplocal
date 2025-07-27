// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_connection_cubit.dart';

class ProfileConnectionsState extends Equatable {
  final bool isSearching;
  final bool isDataLoadedBySearch;
  final bool isMyConenctionDataLoading;
  final bool isRequestedConnectionDataLoading;
  final String? error;
  final ProfileConnectionTypeModel connectionListModel;
  const ProfileConnectionsState({
    this.isSearching = false,
    this.isDataLoadedBySearch = false,
    this.isMyConenctionDataLoading = false,
    this.isRequestedConnectionDataLoading = false,
    required this.connectionListModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isSearching,
        isDataLoadedBySearch,
        isMyConenctionDataLoading,
        isRequestedConnectionDataLoading,
        connectionListModel,
        error
      ];

  ProfileConnectionsState copyWith({
    bool? isSearching,
    bool? isDataLoadedBySearch,
    bool? isMyConenctionDataLoading,
    bool? isRequestedConnectionDataLoading,
    ProfileConnectionTypeModel? connectionListModel,
    String? error,
  }) {
    return ProfileConnectionsState(
      isSearching: isSearching ?? false,
      isDataLoadedBySearch: isDataLoadedBySearch ?? this.isDataLoadedBySearch,
      isMyConenctionDataLoading: isMyConenctionDataLoading ?? false,
      isRequestedConnectionDataLoading:
          isRequestedConnectionDataLoading ?? false,
      connectionListModel: connectionListModel ?? this.connectionListModel,
      error: error,
    );
  }
}
