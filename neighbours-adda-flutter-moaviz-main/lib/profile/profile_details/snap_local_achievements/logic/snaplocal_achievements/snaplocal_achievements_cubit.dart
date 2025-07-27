import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/model/achievements_model.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/repository/achievements_repository.dart';

part 'snaplocal_achievements_state.dart';

class SnaplocalAchievementsCubit extends Cubit<SnaplocalAchievementsState> {
  final AchievementsRepository _achievementsRepository;
  SnaplocalAchievementsCubit(this._achievementsRepository)
      : super(SnaplocalAchievementsInitial());

  void fetchAchievements(String userId) async {
    try {
      emit(SnaplocalAchievementsLoading());
      final achievementsModel =
          await _achievementsRepository.fetchAchievements(userId: userId);
      emit(SnaplocalAchievementsLoaded(achievementsModel));
    } catch (e) {
      if (isClosed) {
        return;
      }
      emit(SnaplocalAchievementsError(message: e.toString()));
    }
  }
}
