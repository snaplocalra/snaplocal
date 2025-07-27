// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';

part 'item_condition_selector_state.dart';

class ItemConditionSelectorCubit extends Cubit<ItemConditionSelectorState> {
  final ItemCondition preSelectedType;

  ItemConditionSelectorCubit(this.preSelectedType)
      : super(ItemConditionSelectorState(preSelectedType));

  void switchType(ItemCondition selectedCondition) {
    emit(state.copyWith(itemCondition: selectedCondition));
  }
}
