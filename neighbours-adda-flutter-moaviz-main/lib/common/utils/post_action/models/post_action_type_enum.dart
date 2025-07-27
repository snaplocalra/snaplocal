enum PostActionType {
  group(jsonName: "group"),
  groupPost(jsonName: "group_post"),
  page(jsonName: "page"),
  pagePost(jsonName: "page_post"),
  market(jsonName: "market"),
  job(jsonName: "job");

  final String jsonName;
  const PostActionType({required this.jsonName});

  // factory PostActionType.fromJson(String data) {
  //   switch (data) {
  //     case "group":
  //       return group;
  //     case "group_post":
  //       return groupPost;
  //     case "page":
  //       return page;
  //     case "page_post":
  //       return pagePost;
  //     case "market":
  //       return market;
  //     case "job":
  //       return job;
  //     default:
  //       throw("");
  //   }
  // }
}
