import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/home_banners_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

part 'home_banners_state.dart';

class HomeBannersCubit extends Cubit<HomeBannersState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;
  HomeBannersCubit(
    this.homeDataRepository,
  ) : super(
          HomeBannersState(
            isTopBannersDataLoading: true,
            isBottomBannersDataLoading: true,
            homeBanners: HomeBannersList(
              topBannersList: [],
              bottomBannersList: [],
            ),
          ),
        );

  Future<void> fetchHomeBanners() async {
    try {
      if (state.homeBanners.topBannersList.isEmpty) {
        emit(state.copyWith(isTopBannersDataLoading: true));
      }
      if (state.homeBanners.bottomBannersList.isEmpty) {
        emit(state.copyWith(isBottomBannersDataLoading: true));
      }
      final homeBanners = await homeDataRepository.fetchHomeBanners();
      emit(state.copyWith(
        homeBanners: homeBanners,
        isTopBannersDataLoading: false,
        isBottomBannersDataLoading: false,
      ));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      //Emit the error state
      emit(state.copyWith(
        isTopBannersDataLoading: false,
        isBottomBannersDataLoading: false,
      ));
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  @override
  HomeBannersState? fromJson(Map<String, dynamic> json) {
    return HomeBannersState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeBannersState state) {
    return state.toMap();
  }
}
