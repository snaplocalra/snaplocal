import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDate {
  /// Saturday, November 25, 2023
  static String eMdy(DateTime dateTime) {
    final formatter = DateFormat('EEEE, MMMM d, y');
    return formatter.format(dateTime);
  }

  /// Example: SUN, 15 DEC
  static String convertEEddMMM(DateTime dateTime) {
    final formatter = DateFormat('EEE, dd MMM', 'en_US');
    return formatter.format(dateTime).toUpperCase();
  }

  /// Example: 2023-12-15
  static String selectedDateYYYYMMDD(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  /// Example: 15-12-2023
  static String selectedDateDDMMYYYY(DateTime date) =>
      DateFormat('dd-MM-yyyy').format(date);

  /// Example: 15/12/2023
  static String selectedDateSlashDDMMYYYY(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  /// Example: 15 DEC 23 03:30PM
  static String ddMMampm(DateTime date) =>
      DateFormat('dd MMM yy hh:mma').format(date);

  /// Example: 03:30PM
  static String ampm(DateTime date) => DateFormat('hh:mm a').format(date);

  /// Example: Dec 15, 2023
  static String date(String date) =>
      DateFormat.yMMMd('en_US').format(DateTime.parse(date));

  ///Example: Dec 15 2023
  static String yMMMd(DateTime date) => DateFormat.yMMMd('en_US').format(date);

  /// Example: DateTime object with time 15:30
  static DateTime convertTimeToAMPMDate({required String rawTime}) =>
      DateFormat("HH:mm").parse(rawTime);

  /// Example: 10:45 AM
  static String convertTimeToAMPM({required String rawTime}) =>
      DateFormat.jm().format(DateFormat("HH:mm:ss").parse(rawTime));

  /// Example: 03:30 PM
  static String convertDateTimeToAMPM({required DateTime dateTime}) =>
      DateFormat('hh:mm a').format(dateTime);

  /// Example: 15
  static String selectedDate(DateTime date) => DateFormat('d').format(date);

  /// Example: Thu
  static String selectedWeekDay(DateTime date) => DateFormat('E').format(date);

  ///Example:Monday
  static String fullWeekDay(DateTime dateTime) {
    //extract the week day from the date
    String datePart = DateFormat('EEEE').format(dateTime);
    return datePart;
  }

  /// Example: DateTime object representing the current date with the specified TimeOfDay
  static DateTime timeOfTheDayToDateTime(
    TimeOfDay timeOfDay, {
    DateTime? specifiedDateTime,
  }) {
    DateTime date = specifiedDateTime ?? DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  ///Example: SUN, 10 DEC 9:30PM
  static String formatDateTimeWithTimeOfDayDTMMM(
      DateTime dateTime, TimeOfDay timeOfDay) {
    // Format date part
    String datePart = DateFormat('EEE, dd MMM').format(dateTime);

    // Format time part
    DateTime combinedDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    String timePart = DateFormat.jm().format(combinedDateTime);

    // Combine date and time parts
    return '$datePart $timePart';
  }

  ///Example: Jan 15, 2023 5:30 PM
  static String formatDateTimeWithTimeOfDay(DateTime dateTime) {
    // Format date part
    String datePart = DateFormat('MMM d, y').format(dateTime);

    // Format time part
    String timePart = DateFormat.jm().format(dateTime);

    // Combine date and time parts
    return '$datePart $timePart';
  }

  ///take data time and return 5m ago, 1h ago, 1d ago
  static String timeAgoSinceDate(DateTime date) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);
    if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  ///Example: (12/12/2023) to (25/12/2023)
  static String formatDateRange(DateTimeRange dateRange) {
    return "(${FormatDate.selectedDateSlashDDMMYYYY(dateRange.start)}) to (${FormatDate.selectedDateSlashDDMMYYYY(dateRange.end)})";
  }
}
