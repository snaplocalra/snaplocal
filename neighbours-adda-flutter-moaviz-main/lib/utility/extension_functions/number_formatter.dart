import 'dart:core';

import 'package:intl/intl.dart';

extension NumberFormatter on num {
  String _removeTrailingZero(String value) {
    if (value.endsWith('.0')) {
      return value.substring(0, value.length - 2);
    } else {
      return value;
    }
  }

  String formatPrice() {
    return _removeTrailingZero(NumberFormat('#,##0.0', 'en_US').format(this));
  }

  String formatNumber() {
    final num parsedNumber = num.parse(toString());
    final NumberFormat formatter = NumberFormat('#,##0.0', 'en_US');
    if (parsedNumber >= 1000000000000) {
      return '${_removeTrailingZero(formatter.format(parsedNumber / 1000000000000))}T';
    } else if (parsedNumber >= 1000000000) {
      return '${_removeTrailingZero(formatter.format(parsedNumber / 1000000000))}B';
    } else if (parsedNumber >= 1000000) {
      return '${_removeTrailingZero(formatter.format(parsedNumber / 1000000))}M';
    } else if (parsedNumber >= 1000) {
      return '${_removeTrailingZero(formatter.format(parsedNumber / 1000))}K';
    } else {
      return _removeTrailingZero(formatter.format(parsedNumber));
    }
  }
}
