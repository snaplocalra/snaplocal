class TempCommentIndexModel {
  final int parentCommentIndex;
  final int? childCommentIndex;

  TempCommentIndexModel({
    required this.parentCommentIndex,
    this.childCommentIndex,
  });
}
