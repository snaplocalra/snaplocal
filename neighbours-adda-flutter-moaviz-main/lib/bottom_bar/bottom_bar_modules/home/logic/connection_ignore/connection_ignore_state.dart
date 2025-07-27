part of 'connection_ignore_cubit.dart';

abstract class ConnectionIgnoreState {}

class ConnectionIgnoreInitial extends ConnectionIgnoreState {}

class ConnectionIgnoreLoading extends ConnectionIgnoreState {
  final String userId;
  ConnectionIgnoreLoading(this.userId);
}

class ConnectionIgnoreSuccess extends ConnectionIgnoreState {
  final String userId;
  ConnectionIgnoreSuccess(this.userId);
}

class ConnectionIgnoreError extends ConnectionIgnoreState {
  final String message;
  final String userId;
  ConnectionIgnoreError(this.message, this.userId);
} 