import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_model.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/widgets/report_reason_builder.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ReportScreen extends StatefulWidget {
  final ReportScreenPayload payload;
  const ReportScreen({super.key, required this.payload});

  static const routeName = 'report';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final additionalDetailsController = TextEditingController();
  final ScrollController controller = ScrollController();

  ReportReasonModel? selectedReason;

  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().fetchReportReasons(widget.payload.reportType);
  }

  //Report logic trigger
  void onReport() {
    context.read<ReportCubit>().submitReport(
          additionalDetails: additionalDetailsController.text.trim(),
          payload: widget.payload,
        );
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
          tr(widget.payload.reportType.title),
          style: TextStyle(color: ApplicationColours.themeBlueColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<ReportCubit, ReportState>(
        listener: (context, reportState) {
          final selectedData = reportState.reportReasonList.selectedData;
          //If request success, close the dialog
          if (reportState.requestSuccess) {
            if (mounted) {
              GoRouter.of(context).pop();
            }
          } else if (reportState.reportReasonList.selectedData != null) {
            selectedReason = selectedData;
          }
        },
        builder: (context, reportState) {
          if (reportState.error != null) {
            return ErrorTextWidget(error: reportState.error!);
          } else if (reportState.dataLoading) {
            return const ThemeSpinner(size: 35);
          } else {
            final logs = reportState.reportReasonList.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          tr(widget.payload.reportType.reportQuestion),
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
                        child: ReportReasonBuilder(
                          reportReasons: logs,
                          selectedReason: selectedReason,
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
                ),
                Padding(
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
                          onPressed: reportState.requestLoading
                              ? null
                              : () {
                                  GoRouter.of(context).pop();
                                },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ThemeElevatedButton(
                          disableButton: selectedReason == null,
                          buttonName: tr(LocaleKeys.submit),
                          showLoadingSpinner: reportState.requestLoading,
                          textFontSize: 12,
                          height: mqSize.height * 0.05,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (selectedReason == null) {
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
                )
              ],
            );
          }
        },
      ),
    );
  }
}
