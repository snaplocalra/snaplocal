import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class BlockStatus extends StatelessWidget {
  final bool blockedByAdmin;
  final bool blockedByUser;
  final bool isAdmin;

  final String blockedByPageAdminMessage;
  final String blockedByUserMessage;
  const BlockStatus({
    super.key,
    required this.blockedByAdmin,
    required this.blockedByUser,
    required this.isAdmin,
    required this.blockedByPageAdminMessage,
    required this.blockedByUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAdmin && blockedByAdmin) {
      // return  ErrorTextWidget(error: "This page is not available");
      return ErrorTextWidget(error: blockedByPageAdminMessage);
    } else if (!isAdmin && blockedByUser) {
      return ErrorTextWidget(error: blockedByUserMessage);
    } else {
      return const SizedBox.shrink();
    }
  }
}
