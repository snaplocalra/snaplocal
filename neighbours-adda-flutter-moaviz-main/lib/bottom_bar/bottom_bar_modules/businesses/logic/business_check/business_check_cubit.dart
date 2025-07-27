import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/models/business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/repository/business_details_repository.dart';

part 'business_check_state.dart';

class BusinessCheckCubit extends Cubit<BusinessCheckState> {
  final BusinessDetailsRepository businessDetailsRepository;

  BusinessCheckCubit(this.businessDetailsRepository)
      : super(const BusinessCheckState());

  Future<void> checkBusinessDetails() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final businessDetails =
          await businessDetailsRepository.checkBusinessDetails();
      emit(BusinessCheckState(businessDetailsModel: businessDetails));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }
}
