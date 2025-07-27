// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snap_local/authentication/helper/password_validator/widget/password_strength_display_widget.dart';
import 'package:snap_local/authentication/models/auth_description_type.dart';
import 'package:snap_local/authentication/widgets/standard_login_widgets/auth_image_description_widget.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/social_media/profile/gender/widgets/gender_selection_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'package:snap_local/utility/year_of_birth/model/dob_years_list.dart';

class Step1Widgets extends StatefulWidget {
  final TextEditingController nameController;
  final void Function(int year) onDOBSelected;
  final void Function(GenderEnum selectedGender) onGenderSelected;

  const Step1Widgets({
    super.key,
    required this.nameController,
    required this.onDOBSelected,
    required this.onGenderSelected,
  });

  @override
  State<Step1Widgets> createState() => _Step1WidgetsState();
}

class _Step1WidgetsState extends State<Step1Widgets> {
  int? yearOfBirth;

  @override
  Widget build(BuildContext context) {
    return LanguageChangeBuilder(
      builder: (context, languageChangeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthImageDescriptionWidget(
              authDescriptionType: AuthDescriptionType.signup1,
            ),
            const SizedBox(height: 10),
            TextFieldWithHeading(
              textFieldHeading: tr(LocaleKeys.fullName),
              child: ThemeTextFormField(
                controller: widget.nameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-z,A-Z, ]'),
                  ),
                ],
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                hint: tr(LocaleKeys.enterYourName),
                style: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle(fontSize: 14),
                fillColor: const Color(0x80F3F3F3),
                maxLength: 50,
                validator: (text) =>
                    TextFieldValidator.standardValidatorWithMinLength(
                  text,
                  TextFieldInputLength.fullNameMinLength,
                ),
              ),
            ),
            const SizedBox(height: 10),

            //Year of Birth
            TextFieldWithHeading(
              textFieldHeading: tr(LocaleKeys.yearOfBirth),
              showOptional: true,
              child: ThemeTextFormFieldDropDown(
                hint: tr(LocaleKeys.selectYearOfBirth),
                hintStyle: const TextStyle(fontSize: 14),
                items: DOBYearsList.years.map((year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                value: yearOfBirth,
                onChanged: (int? value) {
                  if (value != null) {
                    widget.onDOBSelected.call(value);
                    yearOfBirth = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            TextFieldHeadingTextWidget(
              padding: const EdgeInsets.symmetric(vertical: 6),
              text: tr(LocaleKeys.gender),
              fontWeight: FontWeight.w500,
            ),
            GenderSelectionWidget(onGenderSelected: widget.onGenderSelected),
          ],
        );
      },
    );
  }
}

class Step2Widgets extends StatefulWidget {
  final TextEditingController passwordController;
  final void Function(bool isValidPassword) onPasswordValidationChanged;

  const Step2Widgets({
    super.key,
    required this.passwordController,
    required this.onPasswordValidationChanged,
  });

  @override
  State<Step2Widgets> createState() => _Step2WidgetsState();
}

class _Step2WidgetsState extends State<Step2Widgets> {
  bool showPassword = false;
  bool showReEnterPassword = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (context, eyeState) {
            return TextFieldWithHeading(
              textFieldHeading: tr(LocaleKeys.password),
              child: ThemeTextFormField(
                controller: widget.passwordController,
                hint: tr(LocaleKeys.enterPassword),
                fillColor: const Color(0x80F3F3F3),
                style: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                ],
                obscureText: !showPassword,
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    showPassword ? FeatherIcons.eye : FeatherIcons.eyeOff,
                    color: Colors.black,
                    size: 18,
                  ),
                  onPressed: () {
                    showPassword = !showPassword;
                    eyeState(() {});
                  },
                ),
                onChanged: (text) {
                  widget.onPasswordValidationChanged.call(text.isNotEmpty);
                },
                validator: (text) => TextFieldValidator.standardValidator(text),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        //Password strength display widget
        PasswordStrengthDisplayWidget(
          alignment: Alignment.centerLeft,
          passwordController: widget.passwordController,
        ),
      ],
    );
  }
}
