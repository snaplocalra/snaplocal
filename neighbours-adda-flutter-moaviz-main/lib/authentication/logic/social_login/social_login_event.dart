part of 'social_login_bloc.dart';

sealed class SocialLoginEvent extends Equatable {
  const SocialLoginEvent();

  @override
  List<Object> get props => [];
}

class GoogleLogin extends SocialLoginEvent {}

class FacebookLogin extends SocialLoginEvent {}

class AppleLogin extends SocialLoginEvent {}
