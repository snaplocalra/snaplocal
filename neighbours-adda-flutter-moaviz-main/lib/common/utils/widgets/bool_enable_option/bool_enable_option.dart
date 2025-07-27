import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_local/common/utils/widgets/type_selection_option.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import 'logic/enable_option/bool_enable_option_cubit.dart';

class BoolEnableOptionWidget extends StatelessWidget {
  final String? title;
  final Widget? headingWidget;
  final bool enable;
  final Function(bool status) onEnableChanged;
  final String? enableText;
  final String? disableText;
  const BoolEnableOptionWidget({
    super.key,
    this.title,
    this.headingWidget,
    required this.enable,
    required this.onEnableChanged,
    this.enableText,
    this.disableText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoolEnableOptionCubit()..setChatEnableOption(enable),
      child: BlocBuilder<BoolEnableOptionCubit, BoolEnableOptionState>(
        builder: (context, state) {
          final isEnable = state.isEnable;
          return Row(
            children: [
              title != null
                  ? Text(
                      tr(title!),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : headingWidget != null
                      ? headingWidget!
                      : const SizedBox.shrink(),
              const Spacer(),

              //Options

              //Enable
              GestureDetector(
                onTap: () {
                  onEnableChanged.call(true);
                  context
                      .read<BoolEnableOptionCubit>()
                      .setChatEnableOption(true);
                },
                child: TypeSelectionOption(
                  title: tr(enableText ?? LocaleKeys.enable),
                  isSelected: isEnable,
                ),
              ),

              //Disable
              GestureDetector(
                onTap: () {
                  onEnableChanged.call(false);
                  context
                      .read<BoolEnableOptionCubit>()
                      .setChatEnableOption(false);
                },
                child: TypeSelectionOption(
                  title: tr(disableText ?? LocaleKeys.disable),
                  isSelected: !isEnable,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
