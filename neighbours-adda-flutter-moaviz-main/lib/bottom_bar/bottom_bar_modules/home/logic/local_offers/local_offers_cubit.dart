import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_offers/local_offers_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalOffersCubit extends Cubit<LocalOffersState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;

  LocalOffersCubit(
    this.homeDataRepository,
  ) : super(
          const LocalOffersState(
            dataLoading: true,
            offers: [],
          ),
        );

  Future<void> fetchLocalOffers() async {
    try {
      if (state.offers.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final response = await homeDataRepository.fetchLocalOffers();
      emit(state.copyWith(
        offers: response.data,
        dataLoading: false,
      ));
      return;
    } catch (e) {
      print(e.toString());
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.offers.isEmpty) {
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
  LocalOffersState? fromJson(Map<String, dynamic> json) {
    return LocalOffersState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalOffersState state) {
    return state.toMap();
  }
} 