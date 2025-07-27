import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/models/winners_model.dart';

part 'winners_state.dart';

class WinnersCubit extends Cubit<WinnersState> {
  final HallOfFameRepository hallOfFameRepository;

  WinnersCubit(this.hallOfFameRepository)
      : super(WinnersState(winnersListModel: WinnersListModel.emptyModel()));

  Future<void> fetchWinners({bool loadMoreData = false}) async {
    try {
      if (state.winnersListModel.data.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      //Late initial for the feed post
      late WinnersListModel winnersList;

      if (loadMoreData) {
        //Run the fetch winnersList API, if it is not the last page.
        if (!state.winnersListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          state.winnersListModel.paginationModel.currentPage += 1;

          winnersList = await hallOfFameRepository.fetchWinners(
              page: state.winnersListModel.paginationModel.currentPage);
          //emit the updated state.
          emit(state.copyWith(
            winnersListModel:
                state.winnersListModel.paginationCopyWith(newData: winnersList),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        winnersList = await hallOfFameRepository.fetchWinners(page: 1);
        emit(state.copyWith(winnersListModel: winnersList));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.winnersListModel.data.isEmpty) {
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
