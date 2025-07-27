// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';

part 'sell_type_selector_state.dart';

class SellTypeSelectorCubit extends Cubit<SellTypeSelectorState> {
  final SellType preSelectedType;

  SellTypeSelectorCubit(this.preSelectedType)
      : super(SellTypeSelectorState(preSelectedType));

  void switchType(SellType selectedType) {
    emit(state.copyWith(sellType: selectedType));
  }
}
