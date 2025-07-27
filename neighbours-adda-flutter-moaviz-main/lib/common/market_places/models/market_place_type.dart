enum MarketPlaceType {
  localBusiness(jsonName: "local_business"),
  offerCoupon(jsonName: "offer_coupon"),
  job(jsonName: "job"),
  buySell(jsonName: "buy_sell");

  final String jsonName;
  const MarketPlaceType({required this.jsonName});
}
