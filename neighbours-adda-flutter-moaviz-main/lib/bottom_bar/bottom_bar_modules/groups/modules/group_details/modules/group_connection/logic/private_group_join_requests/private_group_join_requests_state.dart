// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'private_group_join_requests_cubit.dart';

class PrivateGroupJoinRequestsState extends Equatable {
  final bool dataLoading;
  final GroupConnectionListModel? groupConnectionListModel;
  final String? error;

  const PrivateGroupJoinRequestsState({
    this.dataLoading = false,
    this.groupConnectionListModel,
    this.error,
  });

  bool get groupConnectionListAvailable => groupConnectionListModel != null;

  @override
  List<Object?> get props => [dataLoading, groupConnectionListModel, error];

  PrivateGroupJoinRequestsState copyWith({
    bool? dataLoading,
    GroupConnectionListModel? groupConnectionListModel,
    String? error,
  }) {
    return PrivateGroupJoinRequestsState(
      dataLoading: dataLoading ?? false,
      groupConnectionListModel:
          groupConnectionListModel ?? this.groupConnectionListModel,
      error: error,
    );
  }
}
