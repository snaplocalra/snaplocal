import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_model.dart';
import 'package:snap_local/common/utils/report/widgets/reason_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class ReportReasonBuilder extends StatelessWidget {
  final List<ReportReasonModel> reportReasons;
  final ReportReasonModel? selectedReason;
  const ReportReasonBuilder({
    super.key,
    this.selectedReason,
    required this.reportReasons,
  });

  @override
  Widget build(BuildContext context) {
    return reportReasons.isEmpty
        ? const ErrorTextWidget(error: "No reason available")
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: reportReasons.length,
            itemBuilder: (context, index) {
              final reason = reportReasons[index];
              return ReasonWidget(
                currentReason: reason,
                selectedReason: selectedReason,
                onChanged: (value) {
                  context.read<ReportCubit>().selectReason(reason.id);
                },
              );
            },
          );
  }
}
