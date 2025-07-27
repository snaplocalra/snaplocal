import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/report/model/report_model.dart';

class ReasonWidget extends StatelessWidget {
  final ReportReasonModel? selectedReason;
  final ReportReasonModel currentReason;
  final void Function(ReportReasonModel? value) onChanged;
  const ReasonWidget({
    super.key,
    this.selectedReason,
    required this.currentReason,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged.call(currentReason);
      },
      child: Row(
        children: [
          Radio<ReportReasonModel>(
            value: currentReason,
            groupValue: selectedReason,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              currentReason.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

    );
  }
}
