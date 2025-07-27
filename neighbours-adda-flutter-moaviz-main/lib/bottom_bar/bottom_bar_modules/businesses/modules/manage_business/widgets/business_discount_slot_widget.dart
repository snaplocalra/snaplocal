import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/logic/manage_discount/manage_discount_cubit.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class BusinessDiscountSlotWidget extends StatelessWidget {
  final String heading;
  const BusinessDiscountSlotWidget({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageDiscountOptionCubit, ManageDiscountOptionState>(
      builder: (context, state) {
        final logs = state.businessDiscountOptionList.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFieldHeadingTextWidget(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  text: heading,
                  fontWeight: FontWeight.w500,
                ),

                //Add more button
                GestureDetector(
                  onTap: () =>
                      context.read<ManageDiscountOptionCubit>().addOption(),
                  child: Text(
                    logs.isEmpty
                        ? "+ ${tr(LocaleKeys.add)}".toUpperCase()
                        : "+ ${tr(LocaleKeys.addMore)}".toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: ApplicationColours.themePinkColor,
                    ),
                  ),
                ),
              ],
            ),
            state.dataLoading
                ? const ThemeSpinner(size: 25)
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final optionDetails = logs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BusinessDiscountOptionTextField(
                                key: Key(
                                    "${optionDetails.value}-${optionDetails.discountOn}"),
                                text: optionDetails.value,
                                onChanged: (text) {
                                  context
                                      .read<ManageDiscountOptionCubit>()
                                      .addDiscountValue(text, index);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),

                                  //don't allow the space
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: BusinessDiscountOptionTextField(
                                      key: Key(
                                          "${optionDetails.value}-${optionDetails.discountOn}"),
                                      maxLength: TextFieldInputLength
                                          .discountDetailsMaxLength,
                                      validator: (text) => TextFieldValidator
                                          .standardValidatorWithMinLength(
                                        text,
                                        TextFieldInputLength
                                            .discountDetailsMinLength,
                                        isOptional: true,
                                      ),
                                      text: optionDetails.discountOn,
                                      hint: "Discount on",
                                      onChanged: (text) {
                                        context
                                            .read<ManageDiscountOptionCubit>()
                                            .addDiscountOn(text, index);
                                      },
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),

                                  const SizedBox(width: 5),

                                  //Don't show the remove option for the 1st 2 element
                                  Visibility(
                                    visible: index > 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: GestureDetector(
                                        onTap: () => context
                                            .read<ManageDiscountOptionCubit>()
                                            .removeOption(index),
                                        child: Icon(
                                          Icons.cancel,
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}

class BusinessDiscountOptionTextField extends StatelessWidget {
  final String? hint;
  final String text;
  final Function(String text) onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String?)? validator;
  const BusinessDiscountOptionTextField({
    super.key,
    required this.text,
    this.hint,
    required this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeTextFormField(
      hint: hint,
      initialValue: text,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      hintStyle: const TextStyle(fontSize: 14),
      style: const TextStyle(fontSize: 14, height: 1.5),
      textCapitalization: TextCapitalization.words,
      maxLength: maxLength,
      validator: validator,
    );
  }
}
