part of 'user_name_text_field_controller_cubit.dart';

sealed class UserNameTextFieldControllerState extends Equatable {
  const UserNameTextFieldControllerState();

  @override
  List<Object> get props => [];
}

final class DefaultUserNameTextField extends UserNameTextFieldControllerState {}

final class PhoneTextField extends UserNameTextFieldControllerState {}

final class EmailTextField extends UserNameTextFieldControllerState {}
