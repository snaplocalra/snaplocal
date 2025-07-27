import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_level/model/profile_level_model.dart';
import 'package:snap_local/profile/profile_level/repository/profile_level_repository.dart';

part 'profile_level_state.dart';

class ProfileLevelCubit extends Cubit<ProfileLevelState> {
  final ProfileLevelRepository _profileLevelRepository;

  ProfileLevelCubit(this._profileLevelRepository)
      : super(ProfileLevelInitial());

  Future<void> fetchProfileLevels(String userId) async {
    try {
      emit(ProfileLevelLoading());
      final profileLevel =
          await _profileLevelRepository.fetchProfileLevels(userId);
      emit(ProfileLevelLoaded(profileLevel));
    } catch (e) {
      emit(ProfileLevelError(e.toString()));
    }
  }
}
