class DOBYearsList {
  static final List<int> years = List.generate(
    //Need to show the year count from 1940 to 16 years back from current year
    DateTime.now().year - 1940 - 16,
    (index) => (1940 + index),
  ).reversed.toList();
}
