import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_location_type_selector/poll_location_type_selector_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PollLocationTypeSelectorWidget extends StatelessWidget {
  const PollLocationTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollLocationTypeSelectorCubit,
        PollLocationTypeSelectorState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PollLocationTypeRadioButton(
              selectedValue: state.selectedLocationType,
              pollLocationType: PollLocationTypeEnum.local,
            ),
            PollLocationTypeRadioButton(
              selectedValue: state.selectedLocationType,
              pollLocationType: PollLocationTypeEnum.global,
            ),
          ],
        );
      },
    );
  }
}

class PollLocationTypeRadioButton extends StatelessWidget {
  final PollLocationTypeEnum selectedValue;
  final PollLocationTypeEnum pollLocationType;

  const PollLocationTypeRadioButton({
    super.key,
    required this.selectedValue,
    required this.pollLocationType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          context
              .read<PollLocationTypeSelectorCubit>()
              .switchType(pollLocationType);
        },
        child: Row(
          children: [
            Radio<PollLocationTypeEnum>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: ApplicationColours.themePinkColor,
              value: pollLocationType,
              groupValue: selectedValue,
              onChanged: (value) {
                context
                    .read<PollLocationTypeSelectorCubit>()
                    .switchType(pollLocationType);
              },
            ),
            Text(tr(pollLocationType.displayName)),
          ],
        ),
      ),
    );
  }
}
