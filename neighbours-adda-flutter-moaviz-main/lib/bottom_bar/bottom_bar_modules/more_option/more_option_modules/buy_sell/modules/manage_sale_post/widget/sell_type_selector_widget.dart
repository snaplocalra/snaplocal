import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/logic/sell_type_selector/sell_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SellTypeSelector extends StatelessWidget {
  final SellType preSelectedType;
  final void Function(SellType sellType) onSelection;
  const SellTypeSelector({
    super.key,
    required this.preSelectedType,
    required this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellTypeSelectorCubit, SellTypeSelectorState>(
      listener: (context, sellTypeSelectorState) {
        //call back with the selected type
        onSelection.call(sellTypeSelectorState.sellType);
      },
      builder: (context, sellTypeSelectorState) {
        final selectedType = sellTypeSelectorState.sellType;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SellTypeButton(
              sellType: SellType.sell,
              isSelected: selectedType == SellType.sell,
            ),
            _SellTypeButton(
              sellType: SellType.free,
              isSelected: selectedType == SellType.free,
            ),
          ],
        );
      },
    );
  }
}

class _SellTypeButton extends StatelessWidget {
  final bool isSelected;
  final SellType sellType;

  const _SellTypeButton({
    this.isSelected = false,
    required this.sellType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            context.read<SellTypeSelectorCubit>().switchType(sellType);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color:
                  isSelected ? ApplicationColours.themeBlueColor : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: ApplicationColours.themeBlueColor),
            ),
            child: Text(
              tr(sellType.displayName),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : ApplicationColours.themeBlueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
