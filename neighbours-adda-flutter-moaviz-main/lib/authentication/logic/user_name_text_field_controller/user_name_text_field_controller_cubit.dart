import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_name_text_field_controller_state.dart';

class UserNameTextFieldControllerCubit
    extends Cubit<UserNameTextFieldControllerState> {
  UserNameTextFieldControllerCubit() : super(DefaultUserNameTextField());

  void checkUserNameType(String userName) {
    if (userName.isEmpty) {
      emit(DefaultUserNameTextField());
    }
    //If the whole string is a number, then it is a mobile number
    else if (RegExp(r'^[0-9]*$').hasMatch(userName)) {
      emit(PhoneTextField());
    } else {
      emit(EmailTextField());
    }
  }
}
