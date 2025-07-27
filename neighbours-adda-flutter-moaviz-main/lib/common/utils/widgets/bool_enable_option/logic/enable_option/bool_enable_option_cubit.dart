import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bool_enable_option_state.dart';

class BoolEnableOptionCubit extends Cubit<BoolEnableOptionState> {
  BoolEnableOptionCubit() : super(const BoolEnableOptionState(isEnable: false));

  //set option
  void setChatEnableOption(bool newStatus) {
    emit(BoolEnableOptionState(isEnable: newStatus));
  }
}
