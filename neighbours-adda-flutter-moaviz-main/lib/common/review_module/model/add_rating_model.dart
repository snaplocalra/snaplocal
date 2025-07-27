class AddRatingModel {
  final String? id;
  final String postId;
  final String comment;
  final double rating;
  final String review;

  AddRatingModel({
    this.id,
    required this.postId,
    required this.comment,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_id': postId,
      'comment': comment,
      'rating': rating,
      'review': review,
    };
  }
}
