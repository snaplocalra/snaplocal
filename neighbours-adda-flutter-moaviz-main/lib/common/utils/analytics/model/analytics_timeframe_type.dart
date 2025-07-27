enum AnalyticsTimeframeType {
  daily(jsonValue: 'daily', displayValue: 'Daily'),
  lastMonth(jsonValue: 'last_month', displayValue: 'Last Month'),
  last3Months(jsonValue: 'last_3_months', displayValue: 'Last 3 Months'),
  last6Months(jsonValue: 'last_6_months', displayValue: 'Last 6 Months'),
  lastOneYear(jsonValue: 'last_one_year', displayValue: 'Last One Year');


  final String jsonValue;
  final String displayValue;

  const AnalyticsTimeframeType({
    required this.jsonValue,
    required this.displayValue,
  });
}
