part of 'item_condition_selector_cubit.dart';

class ItemConditionSelectorState extends Equatable {
  final ItemCondition itemCondition;
  const ItemConditionSelectorState(this.itemCondition);

  @override
  List<Object> get props => [itemCondition];

  ItemConditionSelectorState copyWith({ItemCondition? itemCondition}) {
    return ItemConditionSelectorState(itemCondition ?? this.itemCondition);
  }
}
