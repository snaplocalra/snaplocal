// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends LoginEvent {
  final RegisterUserModel registerUserModel;
  final RegistrationType registrationType;

  const RegisterUser({
    required this.registerUserModel,
    required this.registrationType,
  });
  @override
  List<Object> get props => [registerUserModel, registrationType];
}

class LogInUser extends LoginEvent {
  final String userName;
  final String password;

  const LogInUser({
    required this.userName,
    required this.password,
  });
  @override
  List<Object> get props => [userName, password];
}

class VerifyUserName extends LoginEvent {
  final String userName;

  const VerifyUserName({
    required this.userName,
  });
  @override
  List<Object> get props => [userName];
}

class ResendOTP extends LoginEvent {
  final String userName;
  final bool isForgotPassword;

  const ResendOTP({
    required this.userName,
    this.isForgotPassword = false,
  });
  @override
  List<Object> get props => [userName, isForgotPassword];
}

class ForgotPassword extends LoginEvent {
  final String userName;
  const ForgotPassword({
    required this.userName,
  });
  @override
  List<Object> get props => [userName];
}

class VerifyOTP extends LoginEvent {
  final String otp;
  final String userName;
  final bool isForgotPassword;

  const VerifyOTP({
    required this.otp,
    required this.userName,
    this.isForgotPassword = false,
  });
  @override
  List<Object> get props => [otp, userName, isForgotPassword];
}

class ChangePassword extends LoginEvent {
  final String newPassword;
  final String userName;
  const ChangePassword({
    required this.newPassword,
    required this.userName,
  });
  @override
  List<Object> get props => [newPassword, userName];
}
