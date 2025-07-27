import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/report_local_chat_spam/report_local_chat_spam_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/widgets/report_local_chat_spam_reason_builder.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'dart:convert';

class ReportLocalChatSpamUserScreen extends StatefulWidget {
  final String userId;
  final String? screenshot;
  final String? reportMessage;
  const ReportLocalChatSpamUserScreen({
    super.key,
    required this.userId,
    this.screenshot,
    this.reportMessage,
  });

  static const routeName = 'report_local_chat_spam_user';

  @override
  State<ReportLocalChatSpamUserScreen> createState() =>
      _ReportLocalChatSpamUserScreenState();
}

class ScreenshotPreviewWidget extends StatelessWidget {
  final String screenshot;

  const ScreenshotPreviewWidget({
    super.key,
    required this.screenshot,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Image.memory(
                    base64Decode(screenshot),
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.memory(
                  base64Decode(screenshot),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportLocalChatSpamUserScreenState
    extends State<ReportLocalChatSpamUserScreen> {
  final additionalDetailsController = TextEditingController();
  final ScrollController controller = ScrollController();

  void onReport() {
    print("onReport");
    print(widget.userId);
    print(additionalDetailsController.text.trim());
    final currentState = context.read<ReportLocalChatSpamCubit>().state;
    print(currentState.reportReasonList.selectedData?.id);
    print(
        "Screenshot: ${widget.screenshot?.substring(0, 20)}..."); // Print first 20 chars for debugging

    if (widget.screenshot == null) {
      ThemeToast.errorToast("Screenshot not available");
      return;
    }

    context
        .read<ReportLocalChatSpamCubit>()
        .submitReport(
          flaggedUserId: widget.userId,
          reasonId: currentState.reportReasonList.selectedData?.id ?? '',
          additionalDetails: additionalDetailsController.text.trim(),
          image: widget.screenshot,
          reportMessage: widget.reportMessage,
        )
        .then((_) {
      ThemeToast.successToast("Report spam submitted successfully");
      GoRouter.of(context).pop();
    }).catchError((error) {
      ThemeToast.errorToast(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ReportLocalChatSpamCubit>().fetchReportReasons();
  }

  @override
  void dispose() {
    additionalDetailsController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: ThemeAppBar(
        title: Text(
          tr(LocaleKeys.reportSpam),
          style: TextStyle(color: ApplicationColours.themeBlueColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.screenshot != null)
              ScreenshotPreviewWidget(screenshot: widget.screenshot!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red, // Changed to red
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.reportMessage ?? '',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<ReportLocalChatSpamCubit, ReportLocalChatSpamState>(
              buildWhen: (previous, current) {
                // Only rebuild when necessary state changes occur
                return previous.reportReasonList.selectedData !=
                        current.reportReasonList.selectedData ||
                    previous.requestSuccess != current.requestSuccess ||
                    previous.error != current.error ||
                    previous.dataLoading != current.dataLoading;
              },
              builder: (context, state) {
                if (state.error != null) {
                  return ErrorTextWidget(error: state.error!);
                } else if (state.dataLoading) {
                  return const ThemeSpinner(size: 35);
                } else {
                  final logs = state.reportReasonList.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            tr(LocaleKeys.whyDoYouWantToReportThisUser),
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: mqSize.height * 0.4,
                          ),
                          child: ReportLocalChatSpamReasonBuilder(
                            reportReasons: logs,
                            selectedReason: state.reportReasonList.selectedData,
                            onReasonSelected: (reason) {
                              context
                                  .read<ReportLocalChatSpamCubit>()
                                  .selectReason(reason.id);
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        WidgetHeading(title: tr(LocaleKeys.additionalDetails)),
                        const SizedBox(height: 5),
                        ThemeTextFormField(
                          controller: additionalDetailsController,
                          minLines: 6,
                          maxLines: 10,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          contentPadding: const EdgeInsets.all(10),
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.0,
                          ),
                          maxLength:
                              TextFieldInputLength.reportDescriptionMaxLength,
                          validator: (value) =>
                              TextFieldValidator.standardValidatorWithMinLength(
                            value,
                            TextFieldInputLength.reportDescriptionMinLength,
                            isOptional: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            BlocBuilder<ReportLocalChatSpamCubit, ReportLocalChatSpamState>(
              buildWhen: (previous, current) {
                return previous.requestLoading != current.requestLoading ||
                    previous.reportReasonList.selectedData !=
                        current.reportReasonList.selectedData;
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ThemeElevatedButton(
                          buttonName: tr(LocaleKeys.cancel),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textFontSize: 12,
                          height: mqSize.height * 0.05,
                          padding: EdgeInsets.zero,
                          onPressed: state.requestLoading
                              ? null
                              : () {
                                  GoRouter.of(context).pop();
                                },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ThemeElevatedButton(
                          disableButton:
                              state.reportReasonList.selectedData == null,
                          buttonName: tr(LocaleKeys.submit),
                          showLoadingSpinner: state.requestLoading,
                          textFontSize: 12,
                          height: mqSize.height * 0.05,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (state.reportReasonList.selectedData == null) {
                              ThemeToast.errorToast("Reason not selected");
                              return;
                            } else {
                              onReport();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
