import 'dart:convert';

import 'package:flutter/material.dart';

extension DateTimeRangeExtension on DateTimeRange {
  //to json
  String toJson() => jsonEncode({
        'from': start.millisecondsSinceEpoch,
        'to': end.millisecondsSinceEpoch,
      });
}
