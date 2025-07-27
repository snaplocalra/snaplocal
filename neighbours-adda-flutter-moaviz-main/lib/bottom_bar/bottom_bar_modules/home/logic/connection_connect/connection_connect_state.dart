part of 'connection_connect_cubit.dart';

abstract class ConnectionConnectState {}

class ConnectionConnectInitial extends ConnectionConnectState {}

class ConnectionConnectLoading extends ConnectionConnectState {
  final String userId;
  ConnectionConnectLoading(this.userId);
}

class ConnectionConnectSuccess extends ConnectionConnectState {
  final String userId;
  ConnectionConnectSuccess(this.userId);
}

class ConnectionConnectError extends ConnectionConnectState {
  final String message;
  final String userId;
  ConnectionConnectError(this.message, this.userId);
} 