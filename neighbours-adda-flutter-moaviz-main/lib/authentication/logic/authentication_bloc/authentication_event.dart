// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class AllowAnonymously extends AuthenticationEvent {}

class OpenAuth extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String accessToken;
  final String userId;
  const LoggedIn({
    required this.accessToken,
    required this.userId,
  });
  @override
  List<Object> get props => [accessToken, userId];
}

class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
  @override
  List<Object> get props => [];
}
