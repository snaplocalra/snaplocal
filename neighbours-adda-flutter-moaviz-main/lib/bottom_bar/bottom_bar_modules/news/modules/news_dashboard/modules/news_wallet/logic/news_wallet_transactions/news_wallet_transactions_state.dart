part of 'news_wallet_transactions_cubit.dart';

class NewsWalletTransactionsState extends Equatable {
  final String? error;
  final bool dataLoading;
  final NewsWalletTransactionsList newsWalletTransactions;

  const NewsWalletTransactionsState({
    this.error,
    this.dataLoading = false,
    required this.newsWalletTransactions,
  });

  @override
  List<Object?> get props => [error, dataLoading, newsWalletTransactions];

  NewsWalletTransactionsState copyWith({
    String? error,
    bool? dataLoading,
    NewsWalletTransactionsList? newsWalletTransactions,
  }) {
    return NewsWalletTransactionsState(
      error: error,
      dataLoading: dataLoading ?? false,
      newsWalletTransactions:
          newsWalletTransactions ?? this.newsWalletTransactions,
    );
  }
}
