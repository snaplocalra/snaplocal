import 'package:flutter/material.dart';

class Pick {
  Future<DateTime?> date(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    Locale? locale,
  }) async {
    return await showDatePicker(
      context: context,
      locale: locale,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(DateTime.now().year + 1),
    ).then((selectedDate) {
      if (selectedDate != null) {
        return selectedDate;
      }
      return null;
    });
  }

  Future<TimeOfDay?> time(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    late TimeOfDay time;
    if (initialTime != null) {
      // time = TimeOfDay.fromDateTime(initialTime);
      time = initialTime;
    } else {
      time = TimeOfDay.now();
    }

    return await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(),
          child: TimePickerDialog(initialTime: time),
        );
      },
    ).then(
      (value) {
        if (value == null) {
          if (initialTime == null) {
            return null;
          } else {
            // return FormatDate.timeOfTheDayToDateTime(time);
            return time;
          }
        } else {
          // return FormatDate.timeOfTheDayToDateTime(value);
          return value;
        }
      },
    );
  }
}
