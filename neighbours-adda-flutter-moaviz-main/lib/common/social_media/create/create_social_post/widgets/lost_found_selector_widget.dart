import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/lost_found_type_selector/lost_found_type_selector_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class LostFoundSelector extends StatelessWidget {
  final LostFoundType preSelectedType;
  final void Function(LostFoundType lostFoundType) onSelection;
  const LostFoundSelector({
    super.key,
    required this.preSelectedType,
    required this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LostFoundTypeSelectorCubit(preSelectedType),
      child:
          BlocConsumer<LostFoundTypeSelectorCubit, LostFoundTypeSelectorState>(
        listener: (context, lostFoundTypeSelectorState) {
          //call back with the selected type
          onSelection.call(lostFoundTypeSelectorState.lostFoundType);
        },
        builder: (context, lostFoundTypeSelectorState) {
          final selectedType = lostFoundTypeSelectorState.lostFoundType;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LostFoundButton(
                lostFoundType: LostFoundType.lost,
                isSelected: selectedType == LostFoundType.lost,
              ),
              LostFoundButton(
                lostFoundType: LostFoundType.found,
                isSelected: selectedType == LostFoundType.found,
              ),
            ],
          );
        },
      ),
    );
  }
}

class LostFoundButton extends StatelessWidget {
  final bool isSelected;
  final LostFoundType lostFoundType;

  const LostFoundButton({
    super.key,
    this.isSelected = false,
    required this.lostFoundType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            context
                .read<LostFoundTypeSelectorCubit>()
                .switchType(lostFoundType);
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
              lostFoundType.displayName,
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
