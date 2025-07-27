enum MediaUploadType {
  profile(path: "profile_pic"),
  business(path: "business"),
  market(path: "market"),
  group(path: "group"),
  page(path: "page"),
  post(path: "post"),
  event(path: "event"),
  poll(path: "poll"),
  job(path: "job"),
  news(path: "news");

  final String path;
  const MediaUploadType({required this.path});
}
