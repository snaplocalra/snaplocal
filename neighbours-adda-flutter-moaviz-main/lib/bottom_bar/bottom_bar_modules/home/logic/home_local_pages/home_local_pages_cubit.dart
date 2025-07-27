import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_page_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

part 'home_local_pages_state.dart';

class HomeLocalPagesCubit extends Cubit<HomeLocalPagesState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;
  HomeLocalPagesCubit(
    this.homeDataRepository,
  ) : super(
          const HomeLocalPagesState(
            dataLoading: true,
            localPages: [],
          ),
        );

  Future<void> fetchHomeLocalPages() async {
    try {
      if (state.localPages.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final localPagesResponse = await homeDataRepository.fetchHomeLocalPages();
      emit(state.copyWith(
        localPages: localPagesResponse.data,
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
      if (state.localPages.isEmpty) {
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

  @override
  HomeLocalPagesState? fromJson(Map<String, dynamic> json) {
    return HomeLocalPagesState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeLocalPagesState state) {
    return state.toMap();
  }
} 