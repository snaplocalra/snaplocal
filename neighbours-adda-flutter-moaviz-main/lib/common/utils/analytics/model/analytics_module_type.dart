enum AnalyticsModuleType {
  group(displayValue: "Group", jsonValue: "group"),
  page(displayValue: "Page", jsonValue: "page"),
  business(displayValue: "Business", jsonValue: "business"),
  event(displayValue: "Event", jsonValue: "event"),
  buyAndSell(displayValue: "Buy & Sell", jsonValue: "buy_sell"),
  poll(displayValue: "Poll", jsonValue: "poll"),
  job(displayValue: "Job", jsonValue: "job"),
  profile(displayValue: "Profile", jsonValue: "profile");

  final String displayValue;
  final String jsonValue;

  const AnalyticsModuleType({
    required this.displayValue,
    required this.jsonValue,
  });

  factory AnalyticsModuleType.fromString(String value) {
    switch (value) {
      case 'group':
        return group;
      case 'page':
        return page;
      case 'business':
        return business;
      case 'event':
        return event;
      case 'buy_sell':
        return buyAndSell;
      case 'poll':
        return poll;
      case 'job':
        return job;
      case 'profile':
        return profile;
      default:
        throw Exception('Invalid AnalyticsModuleType');
    }
  }
}
