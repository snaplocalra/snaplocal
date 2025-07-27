import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_buy_sell/local_buy_sell_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_buy_sell_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalBuyAndSellCubit extends Cubit<LocalBuyAndSellState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;

  LocalBuyAndSellCubit(
    this.homeDataRepository,
  ) : super(
          const LocalBuyAndSellState(
            dataLoading: true,
            buyAndSellItems: [],
          ),
        );

  Future<void> fetchLocalBuyAndSellItems() async {
    try {
      if (state.buyAndSellItems.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final response = await homeDataRepository.fetchLocalBuyAndSellItems();
      emit(state.copyWith(
        buyAndSellItems: response.data,
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
      if (state.buyAndSellItems.isEmpty) {
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
  LocalBuyAndSellState? fromJson(Map<String, dynamic> json) {
    return LocalBuyAndSellState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalBuyAndSellState state) {
    return state.toMap();
  }
} 