bool isSameDate(DateTime date1, DateTime date2, {isUTC = false}) {
  if (isUTC) {
    date1 = date1.toUtc();
    date2 = date2.toUtc();
  }
  final isSameDate = date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
  return isSameDate;
}
