import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_news/local_news_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalNewsCubit extends Cubit<LocalNewsState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;

  LocalNewsCubit(this.homeDataRepository)
      : super(
          const LocalNewsState(
            dataLoading: true,
            news: [],
          ),
        );

  Future<void> fetchLocalNews() async {
    try {
      if (state.news.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final newsResponse = await homeDataRepository.fetchLocalNews();
      emit(state.copyWith(
        news: newsResponse.data,
        dataLoading: false,
      ));
      return;
    } catch (e) {
      print(e.toString());
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.news.isEmpty) {
        emit(state.copyWith(
          error: e.toString(),
          dataLoading: false,
        ));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  void onSeeAllTapped() {
    // TODO: Implement see all news navigation
  }

  @override
  LocalNewsState? fromJson(Map<String, dynamic> json) {
    return LocalNewsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalNewsState state) {
    return state.toMap();
  }
} 