abstract class CommentUpdateStrategy {
  int updateCommentCount(int existingCount);
}

class IncrementCommentCount implements CommentUpdateStrategy {
  @override
  int updateCommentCount(int existingCount) {
    return ++existingCount;
  }
}

//Replace comment count
class ReplaceCommentCount implements CommentUpdateStrategy {
  final int newCommentCount;

  ReplaceCommentCount(this.newCommentCount);

  @override
  int updateCommentCount(int existingCount) {
    return newCommentCount;
  }
}
