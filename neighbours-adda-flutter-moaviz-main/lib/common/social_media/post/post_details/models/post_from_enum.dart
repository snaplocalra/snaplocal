enum PostFrom {
  feed(jsonName: "feed"),
  group(jsonName: "group"),
  page(jsonName: "page"),
  news(jsonName: "news");

  final String jsonName;
  const PostFrom({required this.jsonName});

  factory PostFrom.fromString(String data) {
    switch (data) {
      case "feed":
        return feed;
      case "group":
        return group;
      case "page":
        return page;
      case "news":
        return news;
      default:
        throw ("Invalid post from type");
    }
  }
}
