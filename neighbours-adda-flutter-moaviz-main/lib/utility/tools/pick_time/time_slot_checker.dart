import 'package:flutter/material.dart';

class TimeSlotChecker {
  /// Check whether the "From Time" is lesser than the "To Time" or not
  /// OR
  /// Check whether the "To Time" is greater than the "From Time" or not
  static bool isValidTime({TimeOfDay? fromTime, TimeOfDay? toTime}) {
    if (fromTime == null || toTime == null) {
      // If either time is null, consider it valid
      return true;
    } else {
      final fromDuration =
          Duration(hours: fromTime.hour, minutes: fromTime.minute);
      final toDuration = Duration(hours: toTime.hour, minutes: toTime.minute);

      if (fromDuration < toDuration) {
        // If the From Time is before the To Time, consider it valid
        return true;
      } else if (fromDuration == toDuration) {
        // If the From Time and To Time are at the same moment, consider it invalid
        return false;
      } else {
        // Otherwise, consider it invalid
        return false;
      }
    }
  }
}
