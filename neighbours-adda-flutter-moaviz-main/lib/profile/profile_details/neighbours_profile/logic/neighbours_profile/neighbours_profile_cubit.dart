import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/model/neighbours_profile_posts_model.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/repository/neighbours_profile_posts_repository.dart';

part 'neighbours_profile_state.dart';

class NeighboursProfileCubit extends Cubit<NeighboursProfileState> {
  final NeighboursProfileRepository neighboursProfileRepository;

  NeighboursProfileCubit(this.neighboursProfileRepository)
      : super(const NeighboursProfileState());

  Future<void> fetchNeighboursProfile(String userId) async {
    try {
      if (state.error != null || state.neighboursProfileModel == null) {
        emit(state.copyWith(dataLoading: true));
      }

      //New state
      final neighboursProfile = await neighboursProfileRepository
          .fetchNeighboursProfile(userId: userId);

      //New state
      emit(state.copyWith(
        isDataLoaded: true,
        neighboursProfileModel: neighboursProfile,
      ));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.neighboursProfileModel != null) {
        ThemeToast.errorToast(e.toString());
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }
}
