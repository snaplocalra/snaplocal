class NewsEarningsDetailsModel {
  final num newsEarnings;
  final num totalNewsEarnings;
  final num maxTransferAmount;

  NewsEarningsDetailsModel({
    required this.newsEarnings,
    required this.totalNewsEarnings,
    required this.maxTransferAmount,
  });

  factory NewsEarningsDetailsModel.fromMap(Map<String, dynamic> map) {
    return NewsEarningsDetailsModel(
      newsEarnings: map['news_earnings'],
      totalNewsEarnings: map['total_news_earnings'],
      maxTransferAmount: map['max_transfer_points'],
    );
  }
}
