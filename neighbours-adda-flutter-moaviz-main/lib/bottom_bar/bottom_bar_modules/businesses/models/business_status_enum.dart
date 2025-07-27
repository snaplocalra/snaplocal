import 'package:flutter/material.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum BusinessStatus {
  open(
    jsonValue: 'open',
    displayValue: LocaleKeys.open,
    color: Colors.green,
  ),
  closed(
    jsonValue: 'closed',
    displayValue: LocaleKeys.closed,
    color: Colors.red,
  ),
  closingSoon(
    jsonValue: 'closing_soon',
    displayValue: LocaleKeys.closingSoon,
    color: Colors.orange,
  ),
  openingSoon(
    jsonValue: 'opening_soon',
    displayValue: LocaleKeys.openingSoon,
    color: Colors.orange,
  );

  final String jsonValue;
  final String displayValue;
  final Color color;

  const BusinessStatus({
    required this.jsonValue,
    required this.displayValue,
    required this.color,
  });

  //is business open
  bool get isBusinessOpen => this == BusinessStatus.open;

  static BusinessStatus fromString(String status) {
    switch (status) {
      case 'open':
        return BusinessStatus.open;
      case 'closed':
        return BusinessStatus.closed;
      case 'closing_soon':
        return BusinessStatus.closingSoon;
      case 'opening_soon':
        return BusinessStatus.openingSoon;
      default:
        throw Exception('Invalid business status');
    }
  }
}
