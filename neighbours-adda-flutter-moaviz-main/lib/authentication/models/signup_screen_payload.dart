import 'package:firebase_auth/firebase_auth.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/models/login_type_enum.dart';

abstract class SignupScreenPayload {
  final RegistrationType registrationType;
  final String userName;
  SignupScreenPayload({
    required this.registrationType,
    required this.userName,
  });
}

//SocialLogin Payload
class SocialLoginPayload implements SignupScreenPayload, SocialLoginUserData {
  final User user;
  @override
  final SocialLoginEvent loginEvent;

  SocialLoginPayload({required this.user, required this.loginEvent});

  @override
  String get userName => user.email ?? user.phoneNumber!;

  @override
  RegistrationType get registrationType => RegistrationType.social;

  @override
  String? get displayName => user.displayName;

  @override
  bool get emailAvailable => user.email != null;
}

//Standard Login Payload
class StandardLoginPayload implements SignupScreenPayload {
  @override
  final String userName;
  StandardLoginPayload({required this.userName});

  @override
  RegistrationType get registrationType => RegistrationType.standard;
}

abstract class SocialLoginUserData {
  final bool emailAvailable;
  final String? displayName;
  final SocialLoginEvent loginEvent;

  SocialLoginUserData({
    required this.emailAvailable,
    required this.displayName,
    required this.loginEvent,
  });
}
