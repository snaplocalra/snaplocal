import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/logic/item_condition_selector/item_condition_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ItemConditionSelector extends StatelessWidget {
  final ItemCondition? preSelectedItemCondition;
  final void Function(ItemCondition) onChanged;
  const ItemConditionSelector({
    super.key,
    this.preSelectedItemCondition,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemConditionSelectorCubit(
        preSelectedItemCondition ?? ItemCondition.brandNew,
      ),
      child:
          BlocConsumer<ItemConditionSelectorCubit, ItemConditionSelectorState>(
        listener: (context, state) {
          onChanged.call(state.itemCondition);
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ItemConditionOption(
                  selectedItemCondition: state.itemCondition,
                  itemCondition: ItemCondition.brandNew,
                ),
                ItemConditionOption(
                  selectedItemCondition: state.itemCondition,
                  itemCondition: ItemCondition.likeNew,
                ),
                ItemConditionOption(
                  selectedItemCondition: state.itemCondition,
                  itemCondition: ItemCondition.used,
                ),
                ItemConditionOption(
                  selectedItemCondition: state.itemCondition,
                  itemCondition: ItemCondition.fair,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ItemConditionOption extends StatelessWidget {
  final ItemCondition selectedItemCondition;
  final ItemCondition itemCondition;

  const ItemConditionOption({
    super.key,
    required this.selectedItemCondition,
    required this.itemCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          context.read<ItemConditionSelectorCubit>().switchType(itemCondition);
        },
        child: Row(
          children: [
            Radio<ItemCondition>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: ApplicationColours.themeBlueColor,
              value: itemCondition,
              groupValue: selectedItemCondition,
              onChanged: (value) {
                context
                    .read<ItemConditionSelectorCubit>()
                    .switchType(itemCondition);
              },
            ),
            Text(tr(itemCondition.displayName)),
          ],
        ),
      ),
    );
  }
}
