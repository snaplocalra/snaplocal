import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_connection_model.dart';

class LocalConnectionsState extends Equatable {
  final List<LocalConnectionModel> connections;
  final bool dataLoading;
  final String? error;

  const LocalConnectionsState({
    this.connections = const [],
    this.dataLoading = true,
    this.error,
  });

  LocalConnectionsState copyWith({
    List<LocalConnectionModel>? connections,
    bool? dataLoading,
    String? error,
  }) {
    return LocalConnectionsState(
      connections: connections ?? this.connections,
      dataLoading: dataLoading ?? this.dataLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [connections, dataLoading, error];
} 