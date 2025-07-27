enum FollowersFrom {
  group(jsonName: "group"),
  page(jsonName: "page");

  final String jsonName;
  const FollowersFrom({required this.jsonName});
}