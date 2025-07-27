import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/profile_settings/models/profile_settings_model.dart';
import 'package:snap_local/profile/profile_settings/repository/profile_settings_repository.dart';
import 'package:snap_local/profile/profile_settings/utility/profile_setting_location_validator.dart';

part 'profile_settings_state.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState>
    with HydratedMixin {
  final ProfileSettingsRepository profileSettingsRepository;
  ProfileSettingsCubit(
    this.profileSettingsRepository,
  ) : super(const ProfileSettingsState());

  Future<void> fetchProfileSettings() async {
    try {
      final isSocialMediaLocationNotAvailable =
          isProfileSettingLocationNotAvailable(state,
              locationType: LocationType.socialMedia);

      if (state.isError ||
          !state.isProfileSettingModelAvailable ||
          (isSocialMediaLocationNotAvailable != null &&
              isSocialMediaLocationNotAvailable)) {
        emit(state.copyWith(dataLoading: true));
      }
      final profileSettings =
          await profileSettingsRepository.fetchProfileSettings();
      emit(state.copyWith(profileSettingsModel: profileSettings));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (!state.isProfileSettingModelAvailable) {
        emit(state.copyWith(error: e.toString()));
      } else {
        ThemeToast.errorToast(e.toString());
      }
    }
  }

  @override
  ProfileSettingsState? fromJson(Map<String, dynamic> json) {
    return ProfileSettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ProfileSettingsState state) {
    return state.toMap();
  }
}
