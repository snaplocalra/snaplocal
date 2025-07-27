enum TimeFrameEnum {
  oneWeek('1_week', '1 Week'),
  oneMonth('1_month', '1 Month'),
  sixMonths('6_months', '6 Months'),
  oneYear('1_year', '1 Year'),
  twentyFourHours('24_hours', '24 Hours');

  final String value;
  final String displayValue;

  const TimeFrameEnum(this.value, this.displayValue);

  factory TimeFrameEnum.fromString(String value) {
    switch (value) {
      case '1_week':
        return TimeFrameEnum.oneWeek;
      case '1_month':
        return TimeFrameEnum.oneMonth;
      case '6_months':
        return TimeFrameEnum.sixMonths;
      case '1_year':
        return TimeFrameEnum.oneYear;
      case '24_hours':
        return TimeFrameEnum.twentyFourHours;
      default:
        throw ArgumentError('Invalid value');
    }
  }
}
