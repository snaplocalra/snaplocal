import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PollTypeSelectorWidget extends StatelessWidget {
  const PollTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollTypeSelectorCubit, PollTypeSelectorState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PollTypeRadioButton(
              selectedValue: state.selectedType,
              pollType: PollTypeEnum.text,
            ),
            PollTypeRadioButton(
              selectedValue: state.selectedType,
              pollType: PollTypeEnum.photo,
            ),
          ],
        );
      },
    );
  }
}

class PollTypeRadioButton extends StatelessWidget {
  final PollTypeEnum selectedValue;
  final PollTypeEnum pollType;

  const PollTypeRadioButton({
    super.key,
    required this.selectedValue,
    required this.pollType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PollTypeSelectorCubit>().switchType(pollType);
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedValue == pollType
              ? ApplicationColours.themePinkColor
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
        ),
        //alignment: Alignment.center,
        child: Row(
          children: [
            if(pollType==PollTypeEnum.text)
                      Icon(
                        Icons.text_fields,
                        size: 15,
                        color: selectedValue == PollTypeEnum.text ? Colors.white : Colors.black,
                      )
                    else
                      Icon(
                        Icons.camera_alt,
                        size: 15,
                        color: selectedValue == PollTypeEnum.photo ? Colors.white : Colors.black,
                      ),
            SizedBox(width: 10,),
            Text(
              tr(pollType.displayName),
              style: TextStyle(
                color: selectedValue == pollType ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(right: 10),
    //   child: GestureDetector(
    //     onTap: () {
    //       context.read<PollTypeSelectorCubit>().switchType(pollType);
    //     },
    //     child: Row(
    //       children: [
    //         Radio<PollTypeEnum>(
    //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //           activeColor: ApplicationColours.themeLightPinkColor,
    //           value: pollType,
    //           groupValue: selectedValue,
    //           onChanged: (value) {
    //             context.read<PollTypeSelectorCubit>().switchType(pollType);
    //           },
    //         ),
    //         if(pollType==PollTypeEnum.text)
    //           Icon(
    //             Icons.text_fields,
    //             size: 15,
    //           )
    //         else
    //           Icon(
    //             Icons.camera_alt,
    //             size: 15,
    //           ),
    //         Text(tr(pollType.displayName)),
    //       ],
    //     ),
    //   ),
    // );
  }
}
