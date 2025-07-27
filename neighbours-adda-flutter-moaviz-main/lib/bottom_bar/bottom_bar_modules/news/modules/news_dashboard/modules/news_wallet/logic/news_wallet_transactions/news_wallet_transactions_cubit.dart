import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/models/news_wallet_transactions_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/repository/news_earnings_repository.dart';

part 'news_wallet_transactions_state.dart';

class NewsWalletTransactionsCubit extends Cubit<NewsWalletTransactionsState> {
  final NewsEarningsRepository newsEarningsRepository;
  NewsWalletTransactionsCubit(this.newsEarningsRepository)
      : super(NewsWalletTransactionsState(
          newsWalletTransactions: NewsWalletTransactionsList.emptyModel(),
        ));

  Future<void> fetchNewsWalletTransactions({bool loadMoreData = false}) async {
    try {
      //Late initial for the notification model
      late NewsWalletTransactionsList newsWalletTransactions;
      if (loadMoreData) {
        //Run the fetch home feed API, if it is not the last page.
        if (!state.newsWalletTransactions.paginationModel.isLastPage) {
          //Increase the current page counter
          state.newsWalletTransactions.paginationModel.currentPage += 1;

          newsWalletTransactions =
              await newsEarningsRepository.fetchNewsWalletTransactions(
            page: state.newsWalletTransactions.paginationModel.currentPage,
          );

          //emit the updated state.
          emit(state.copyWith(
              newsWalletTransactions:
                  state.newsWalletTransactions.paginationCopyWith(
            newData: newsWalletTransactions,
          )));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        emit(state.copyWith(dataLoading: true));
        newsWalletTransactions =
            await newsEarningsRepository.fetchNewsWalletTransactions();
        //Emit the new state if it is the initial load request
        emit(state.copyWith(newsWalletTransactions: newsWalletTransactions));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.newsWalletTransactions.data.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }
}
