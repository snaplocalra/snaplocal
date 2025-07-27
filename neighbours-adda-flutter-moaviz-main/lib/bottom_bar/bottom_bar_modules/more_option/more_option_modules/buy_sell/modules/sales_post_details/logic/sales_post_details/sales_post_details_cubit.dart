import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sale_post_mark_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sales_post_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/repository/sales_post_details_repository.dart';

part 'sales_post_details_state.dart';

class SalesPostDetailsCubit extends Cubit<SalesPostDetailsState> {
  final SalesPostDetailsRepository salesPostDetailsRepository;
  SalesPostDetailsCubit(this.salesPostDetailsRepository)
      : super(const SalesPostDetailsState());

  Future<void> fetchSalesPostDetails(String salesPostId) async {
    try {
      if (state.error != null || !state.isSalesPostDetailAvailable) {
        emit(state.copyWith(dataLoading: true));
      }
      final salesPostDetails = await salesPostDetailsRepository
          .fetchSalesPostDetails(salesPostId: salesPostId);
      emit(state.copyWith(salesPostDetailModel: salesPostDetails));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updatePostSaveStatus(bool newStatus) {
    if (state.salesPostDetailModel != null) {
      emit(state.copyWith(dataLoading: true));
      emit(state.copyWith(
        salesPostDetailModel:
            state.salesPostDetailModel!.copyWith(isSaved: newStatus),
      ));
    }
    return;
  }

  Future<void> markAs({
    required String postId,
    required SalesPostMarkType salesPostMarkType,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await salesPostDetailsRepository.markAs(
        postId: postId,
        salesPostMarkType: salesPostMarkType,
      );
      await fetchSalesPostDetails(postId);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(requestLoading: false));
      ThemeToast.errorToast("Unable to perform the action. Please try again.");
    }
  }
}
