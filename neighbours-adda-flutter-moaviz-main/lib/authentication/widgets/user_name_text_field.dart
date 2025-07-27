import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/user_name_text_field_controller/user_name_text_field_controller_cubit.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({
    super.key,
    required this.userNameController,
  });

  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserNameTextFieldControllerCubit,
        UserNameTextFieldControllerState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("VerifyUserNameTextField"),
          controller: userNameController,
          autofillHints: [
            state is PhoneTextField
                ? AutofillHints.telephoneNumberNational
                : AutofillHints.email,
          ],
          inputFormatters: [
            //do not allow space
            FilteringTextInputFormatter.deny(RegExp('[ ]')),

            //allow only alphanumeric, @, ., _
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),

            //limit the length of the text field if it is phone number
            if (state is PhoneTextField) ...[
              LengthLimitingTextInputFormatter(10)
            ],
          ],
          onChanged: (value) {
            context
                .read<UserNameTextFieldControllerCubit>()
                .checkUserNameType(value);
          },
          decoration: InputDecoration(
            hintText: state is PhoneTextField
                ? tr(LocaleKeys.enterYourPhoneNumber)
                : state is EmailTextField
                    ? tr(LocaleKeys.enterYourEmail)
                    : tr(LocaleKeys.enterYourEmailOrPhoneNumber),
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust border radius as needed
              borderSide:
                  const BorderSide(color: Colors.transparent), // Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust border radius as needed
              borderSide:
                  const BorderSide(color: Colors.transparent), // Border color
            ),
            filled: true,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.only(bottom: 5), // Adjust padding as needed
              child: Icon(
                state is PhoneTextField
                    ? FeatherIcons.phone
                    : state is EmailTextField
                        ? FeatherIcons.mail
                        : FeatherIcons.user,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
