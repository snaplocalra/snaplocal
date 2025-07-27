import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/logic/submit_support_report/submit_support_report_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/model/support_report_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/repository/help_support_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  static const routeName = 'help_and_support';

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    descriptionController.dispose();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitSupportReportCubit(HelpSupportRepository()),
      child: BlocConsumer<SubmitSupportReportCubit, SubmitSupportReportState>(
        listener: (context, submitSupportReportState) {
          if (submitSupportReportState.requestSuccess) {
            GoRouter.of(context).pop();
          }
        },
        builder: (context, submitSupportReportState) {
          return PopScope(
            canPop: willPopScope(!submitSupportReportState.requestLoading),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: ThemeAppBar(
                backgroundColor: Colors.white,
                elevation: 0.2,
                title: Text(
                  tr(LocaleKeys.helpAndSupport),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: Form(
                key: formkey,
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    TextFieldWithHeading(
                      showStarMark: true,
                      textFieldHeading: tr(LocaleKeys.emailId),
                      child: ThemeTextFormField(
                        controller: emailController,
                        hint: tr(LocaleKeys.addYourEmail),
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        style: const TextStyle(fontSize: 14),
                        hintStyle: const TextStyle(fontSize: 14),
                        validator: (value) =>
                            TextFieldValidator.emailValidator(value),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFieldWithHeading(
                      textFieldHeading: tr(LocaleKeys.description),
                      showStarMark: true,
                      child: ThemeTextFormField(
                        controller: descriptionController,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        contentPadding: const EdgeInsets.all(10),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.0,
                        ),
                        minLines: 4,
                        maxLines: 6,
                        hintStyle: const TextStyle(fontSize: 14),
                        validator: (text) =>
                            TextFieldValidator.standardValidator(text),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 20),
                      child: ThemeElevatedButton(
                        buttonName: tr(LocaleKeys.submit),
                        showLoadingSpinner:
                            submitSupportReportState.requestLoading,
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final supportReportModel = SupportReportModel(
                              email: emailController.text.trim(),
                              description: descriptionController.text.trim(),
                            );
                            context
                                .read<SubmitSupportReportCubit>()
                                .submitSupportReport(supportReportModel);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
