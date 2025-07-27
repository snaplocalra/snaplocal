import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  ///If after
  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      if (minute > other.minute) {
        return true;
      }
    }
    return false;
  }

  ///If before
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      if (minute < other.minute) {
        return true;
      }
    }
    return false;
  }
}
