part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class OnBoarding extends AuthenticationState {}

class AnonymousEntry extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated();
  @override
  List<Object> get props => [];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  // final bool isLogout;
  const AuthenticationUnauthenticated();
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {}
