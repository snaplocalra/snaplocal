enum SalesPostMarkType {
  bought(endPoint: "mark_as_bought"),
  markAsAvailable(endPoint: "mark_as_available"),
  unmarkAsBought(endPoint: "unmark_as_bought"),
  soldout(endPoint: "mark_as_sold_out");

  final String endPoint;
  const SalesPostMarkType({required this.endPoint});
}
