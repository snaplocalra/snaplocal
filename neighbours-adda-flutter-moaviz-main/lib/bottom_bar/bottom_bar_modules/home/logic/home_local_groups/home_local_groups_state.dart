part of 'home_local_groups_cubit.dart';

class HomeLocalGroupsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final List<LocalGroupModel> localGroups;

  const HomeLocalGroupsState({
    this.dataLoading = false,
    required this.localGroups,
    this.error,
  });

  @override
  List<Object?> get props => [localGroups, dataLoading, error];

  HomeLocalGroupsState copyWith({
    bool? dataLoading,
    List<LocalGroupModel>? localGroups,
    String? error,
  }) {
    return HomeLocalGroupsState(
      dataLoading: dataLoading ?? this.dataLoading,
      localGroups: localGroups ?? this.localGroups,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataLoading': dataLoading,
      'localGroups': localGroups.map((group) => group.toJson()).toList(),
      'error': error,
    };
  }

  factory HomeLocalGroupsState.fromMap(Map<String, dynamic> map) {
    return HomeLocalGroupsState(
      dataLoading: (map['dataLoading'] ?? false) as bool,
      localGroups: (map['localGroups'] as List)
          .map((group) => LocalGroupModel.fromJson(group as Map<String, dynamic>))
          .toList(),
      error: map['error'] as String?,
    );
  }
} 