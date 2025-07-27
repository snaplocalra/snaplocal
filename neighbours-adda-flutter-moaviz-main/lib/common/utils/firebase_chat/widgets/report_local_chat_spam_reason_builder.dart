import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/report_local_chat_spam/report_local_chat_spam_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/report_local_chat_spam_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ReportLocalChatSpamReasonBuilder extends StatelessWidget {
  final List<ReportLocalChatSpamReasonModel> reportReasons;
  final ReportLocalChatSpamReasonModel? selectedReason;
  final Function(ReportLocalChatSpamReasonModel) onReasonSelected;

  const ReportLocalChatSpamReasonBuilder({
    super.key,
    required this.reportReasons,
    this.selectedReason,
    required this.onReasonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: reportReasons.length,
      itemBuilder: (context, index) {
        final reason = reportReasons[index];
        final isSelected = selectedReason?.id == reason.id;
        return ListTile(
          leading: Radio<ReportLocalChatSpamReasonModel>(
            value: reason,
            groupValue: selectedReason,
            onChanged: (value) {
              if (value != null) {
                onReasonSelected(value);
              }
            },
          ),
          title: Text(reason.reason),
          selected: isSelected,
          selectedTileColor: Colors.grey[100],
        );
      },
    );
  }
} 