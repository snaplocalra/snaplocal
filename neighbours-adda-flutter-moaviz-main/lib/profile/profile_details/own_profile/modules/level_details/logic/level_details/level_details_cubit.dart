// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/level_details/repository/reward_details_repository.dart';

part 'level_details_state.dart';

class LevelDetailsCubit extends Cubit<LevelDetailsState> {
  final LevelDetailsRepository levelDetailsRepository;
  LevelDetailsCubit(this.levelDetailsRepository)
      : super(const LevelDetailsState());

  // void fetchLevelDetails() async {
  //   try {
  //     if (state.rewardDetailsModel == null) {
  //       emit(state.copyWith(dataLoading: true));
  //     }
  //     final rewardDetails = await levelDetailsRepository.fetchRewardDetails();
  //     emit(state.copyWith(rewardDetailsModel: rewardDetails));
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     emit(state.copyWith(error: e.toString()));
  //   }
  // }
}
