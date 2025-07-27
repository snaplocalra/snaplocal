import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/models/news_earnings_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/repository/news_earnings_repository.dart';

part 'news_earnings_state.dart';

class NewsEarningsCubit extends Cubit<NewsEarningsState> {
  final NewsEarningsRepository newsEarningsRepository;
  NewsEarningsCubit(this.newsEarningsRepository) : super(NewsEarningsInitial());

  //Fetch news earnings details
  Future<void> fetchNewsEarningsDetails(String channelId) async {
    try {
      emit(NewsEarningsLoading());
      final newsEarningsDetailsModel =
          await newsEarningsRepository.fetchNewsEarningsDetails(channelId);
      emit(NewsEarningsLoaded(
        newsEarningsDetailsModel: newsEarningsDetailsModel,
      ));
    } catch (e) {
      emit(NewsEarningsLoadFailed(errorMessage: e.toString()));
    }
  }
}
