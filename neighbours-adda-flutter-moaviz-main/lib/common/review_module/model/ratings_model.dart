class RatingsModel {
  final double starRating;
  final int totalReview;
  RatingsModel({
    required this.starRating,
    required this.totalReview,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'star_rating': starRating,
      'total_review': totalReview,
    };
  }

  factory RatingsModel.fromMap(Map<String, dynamic> map) {
    return RatingsModel(
      starRating: double.tryParse(map["star_rating"].toString()) ?? 0,
      totalReview: (map['total_review'] ?? 0) as int,
    );
  }
}
