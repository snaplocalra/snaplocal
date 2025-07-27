// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/common/check_box_with_text/logic/check_box_controller/check_box_controller_cubit.dart';

class CheckBoxWithText extends StatelessWidget {
  final bool initialValue;
  final String title;
  final Color? activeColor;
  final void Function(bool status) onChanged;
  const CheckBoxWithText({
    super.key,
    this.initialValue = false,
    required this.title,
    this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckBoxControllerCubit(initialValue: initialValue),
      child: BlocConsumer<CheckBoxControllerCubit, CheckBoxControllerState>(
        listener: (context, checkBoxControllerState) {
          onChanged.call(checkBoxControllerState.enable);
        },
        builder: (context, checkBoxControllerState) {
          return Row(
            children: [
              Checkbox(
                activeColor: activeColor,
                value: checkBoxControllerState.enable,
                onChanged: (value) {
                  context
                      .read<CheckBoxControllerCubit>()
                      .toggle(value ?? false);
                },
              ),
              Text(tr(title)),
            ],
          );
        },
      ),
    );
  }
}
