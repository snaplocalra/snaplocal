// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_model.dart';
import 'package:snap_local/common/market_places/owner_activity_details/repository/owner_activity_details_repository.dart';

part 'fetch_owner_activity_details_state.dart';

class FetchOwnerActivityDetailsCubit
    extends Cubit<FetchOwnerActivityDetailsState> {
  final OwnerActivityDetailsRepository ownerActivityDetailsRepository;
  FetchOwnerActivityDetailsCubit(this.ownerActivityDetailsRepository)
      : super(const FetchOwnerActivityDetailsState());

  Future<void> fetchOwnerActivityDetails({
    required OwnerActivityType ownerActivityType,
    required String postId,
  }) async {
    try {
      if (state.ownerActivityDetailsModel == null) {
        emit(state.copyWith(dataLoading: true));
      }

      final ownerActivity =
          await ownerActivityDetailsRepository.fetchOwnerActivity(
        postId: postId,
        ownerActivityType: ownerActivityType,
      );
      emit(state.copyWith(ownerActivityDetailsModel: ownerActivity));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }
}
