import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/model/check_news_post_limit_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/repository/check_news_post_limit_repository.dart';

part 'check_news_post_limit_state.dart';

class CheckNewsPostLimitCubit extends Cubit<CheckNewsPostLimitState> {
  final CheckNewsPostLimitRepository _checkNewsPostLimitRepository;

  CheckNewsPostLimitCubit(this._checkNewsPostLimitRepository)
      : super(CheckNewsPostLimitInitial());

  //Check news post limit
  Future<void> checkNewsPostLimit(String newsChannelId) async {
    try {
      emit(CheckNewsPostLimitLoading());
      final checkNewsPostLimitModel =
          await _checkNewsPostLimitRepository.checkNewsPostLimit(newsChannelId);
      emit(CheckNewsPostLimitLoaded(checkNewsPostLimitModel));
    } catch (e) {
      emit(CheckNewsPostLimitFailure(e.toString()));
    }
  }
}
