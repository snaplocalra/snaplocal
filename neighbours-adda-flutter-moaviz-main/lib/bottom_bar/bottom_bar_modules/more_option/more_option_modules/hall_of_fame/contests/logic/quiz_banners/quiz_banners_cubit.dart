import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_banner_type.dart';

part 'quiz_banners_state.dart';

class QuizBannersCubit extends Cubit<QuizBannersState> {
  final HallOfFameRepository hallOfFameRepository;
  QuizBannersCubit(this.hallOfFameRepository) : super(const QuizBannersState());

  Future<void> fetchQuizBanners(QuizBannerType quizBannerType) async {
    try {
      emit(state.copyWith(dataLoading: true));
      final bannerImage =
          await hallOfFameRepository.fetchQuizBanner(quizBannerType);
      emit(state.copyWith(bannerImage: bannerImage));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(error: e.toString()));
    }
  }
}
