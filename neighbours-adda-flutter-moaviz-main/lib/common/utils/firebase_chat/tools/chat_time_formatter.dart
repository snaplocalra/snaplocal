import 'package:intl/intl.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

String formatChatTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate == today) {
    return 'Today';
  } else if (messageDate == yesterday) {
    return 'Yesterday';
  } else {
    return DateFormat('EEEE').format(dateTime);
  }
}

String formatLastChatTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate == today) {
    return FormatDate.convertDateTimeToAMPM(dateTime: dateTime);
  } else if (messageDate == yesterday) {
    return 'Yesterday';
  } else {
    return DateFormat('EEEE').format(dateTime);
  }
}
