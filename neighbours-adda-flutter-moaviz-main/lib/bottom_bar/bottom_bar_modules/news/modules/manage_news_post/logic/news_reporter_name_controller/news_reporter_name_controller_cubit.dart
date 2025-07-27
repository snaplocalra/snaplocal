import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/news_reporter_model.dart';

part 'news_reporter_name_controller_state.dart';

class NewsReporterNameControllerCubit
    extends Cubit<NewsReporterNameControllerState> {
  NewsReporterNameControllerCubit()
      : super(const NewsReporterNameControllerState());

  void assignContributorName(String newsReporterName) {
    if (state.newsReporter == null) {
      emit(state.copyWith(
        newsReporter: NewsReporter(
          name: newsReporterName,
          visibility: true,
        ),
      ));
    } else {
      emit(state.copyWith(
        newsReporter: state.newsReporter!.copyWith(
          name: newsReporterName,
        ),
      ));
    }
  }

  void assignContributorVisibility(bool visibility) {
    if (state.newsReporter == null) {
      return;
    }
    emit(state.copyWith(
      newsReporter: state.newsReporter!.copyWith(visibility: visibility),
    ));
  }
}
