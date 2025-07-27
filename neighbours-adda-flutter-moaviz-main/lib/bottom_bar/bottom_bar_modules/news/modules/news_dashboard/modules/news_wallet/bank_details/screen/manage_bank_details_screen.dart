import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/logic/manage_bank_details/manage_bank_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/logic/models/manage_bank_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/repository/bank_details_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ManageBankDetailsScreen extends StatefulWidget {
  const ManageBankDetailsScreen({super.key});

  static const String routeName = 'manage_bank_details';
  @override
  State<ManageBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<ManageBankDetailsScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final accountHolderName = TextEditingController();
  final accountNumber = TextEditingController();
  final ifscCode = TextEditingController();
  final bankName = TextEditingController();
  final mobileNumber = TextEditingController();

  @override
  void dispose() {
    accountHolderName.dispose();
    accountNumber.dispose();
    ifscCode.dispose();
    bankName.dispose();
    mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageBankDetailsCubit(ManageBankRepository()),
      child: BlocListener<ManageBankDetailsCubit, ManageBankDetailsState>(
        listener: (context, manageBankDetailsState) {
          if (manageBankDetailsState is AddBankDetailsSuccess) {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop(true);
            }
          } else if (manageBankDetailsState is AddBankDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(manageBankDetailsState.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: ThemeAppBar(
            title: Text(
              tr(LocaleKeys.addBankDetails),
              style: TextStyle(color: ApplicationColours.themeBlueColor),
            ),
          ),
          body: Form(
            key: formkey,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                //Account holder name
                TextFieldWithHeading(
                  textFieldHeading: tr(LocaleKeys.accountHolderName),
                  child: ThemeTextFormField(
                    controller: accountHolderName,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z,A-Z, ]'),
                      ),
                    ],
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
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

                //Account number
                TextFieldWithHeading(
                  textFieldHeading: tr(LocaleKeys.acNo),
                  child: ThemeTextFormField(
                    controller: accountNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 14),
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: const Color(0x80F3F3F3),
                    validator: (text) =>
                        TextFieldValidator.standardValidator(text),
                  ),
                ),

                const SizedBox(height: 10),

                //IFSC code
                TextFieldWithHeading(
                  textFieldHeading: tr(LocaleKeys.ifscCode),
                  child: ThemeTextFormField(
                    controller: ifscCode,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z,A-Z,0-9]'),
                      ),
                    ],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 14),
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: const Color(0x80F3F3F3),
                    validator: (text) =>
                        TextFieldValidator.standardValidator(text),
                  ),
                ),

                const SizedBox(height: 10),

                //Bank name
                TextFieldWithHeading(
                  textFieldHeading: tr(LocaleKeys.bankName),
                  child: ThemeTextFormField(
                    controller: bankName,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z,A-Z, ]'),
                      ),
                    ],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 14),
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: const Color(0x80F3F3F3),
                    maxLength: 50,
                    validator: (text) =>
                        TextFieldValidator.standardValidator(text),
                  ),
                ),

                const SizedBox(height: 10),

                //Mobile number
                TextFieldWithHeading(
                  textFieldHeading: tr(LocaleKeys.phoneNumber),
                  child: ThemeTextFormField(
                    controller: mobileNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 14),
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: const Color(0x80F3F3F3),
                    validator: (value) =>
                        TextFieldValidator.phoneNumberValidator(value),
                  ),
                ),

                //Submit button
                BlocBuilder<ManageBankDetailsCubit, ManageBankDetailsState>(
                  builder: (context, addBankDetailsState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ThemeElevatedButton(
                        showLoadingSpinner:
                            addBankDetailsState is AddBankDetailsLoading,
                        buttonName: tr(LocaleKeys.submit),
                        onPressed: () {
                          if (!formkey.currentState!.validate()) {
                            return;
                          }

                          //close keyboard
                          FocusManager.instance.primaryFocus?.unfocus();

                          //Create the manage bank details model
                          final bankDetails = ManageBankDetailsModel(
                            accountHolderName: accountHolderName.text.trim(),
                            accountNumber: accountNumber.text.trim(),
                            ifscCode: ifscCode.text.trim(),
                            bankName: bankName.text.trim(),
                            mobile: mobileNumber.text.trim(),
                          );

                          //Add bank details
                          context
                              .read<ManageBankDetailsCubit>()
                              .addBankDetails(bankDetails);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
