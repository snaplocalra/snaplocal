import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/models/business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/repository/business_details_repository.dart';

part 'business_details_state.dart';

class BusinessDetailsCubit extends Cubit<BusinessDetailsState> {
  final BusinessDetailsRepository businessDetailsRepository;
  BusinessDetailsCubit(this.businessDetailsRepository)
      : super(const BusinessDetailsState());

  Future<void> fetchBusinessDetails(String businessId) async {
    try {
      if (state.error != null || !state.isBusinessViewDetailsAvailable) {
        emit(state.copyWith(dataLoading: true));
      }

      final businessDetails =
          await businessDetailsRepository.fetchBusinessDetails(businessId);
      emit(state.copyWith(businessDetailsModel: businessDetails));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (!state.isBusinessViewDetailsAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }
}
