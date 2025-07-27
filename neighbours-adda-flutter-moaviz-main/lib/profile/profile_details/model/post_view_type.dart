enum PostViewType {
  posts(displayText: 'Posts', jsonValue: 'posts'),
  photos(displayText: 'Photos', jsonValue: 'photos'),
  videos(displayText: 'Videos', jsonValue: 'videos');

  final String displayText;
  final String jsonValue;
  const PostViewType({
    required this.displayText,
    required this.jsonValue,
  });
}

class PostViewTypeList {
  final data = [PostViewType.posts, PostViewType.photos, PostViewType.videos];
}
