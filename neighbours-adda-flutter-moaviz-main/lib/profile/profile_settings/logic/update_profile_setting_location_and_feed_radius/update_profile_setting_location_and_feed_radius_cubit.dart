// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/repository/profile_settings_repository.dart';

part 'update_profile_setting_location_and_feed_radius_state.dart';

class UpdateProfileSettingLocationAndFeedRadiusCubit
    extends Cubit<UpdateProfileSettingLocationState> {
  final ProfileSettingsRepository profileSettingsRepository;
  final ProfileSettingsCubit profileSettingsCubit;
  final ManageProfileDetailsBloc profileDetailsBloc;
  UpdateProfileSettingLocationAndFeedRadiusCubit({
    required this.profileSettingsRepository,
    required this.profileSettingsCubit,
    required this.profileDetailsBloc,
  }) : super(const UpdateProfileSettingLocationState());

  Future<void> updateLocationWithFeedRadius({
    required LocationAddressWithLatLng locationAddressWithLatLong,
    required LocationType locationType,
    required double feedRadius,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      await Future.wait([
        updateFeedRadius(
          feedRadius: feedRadius,
          locationType: locationType,
        ),
        updateLocation(
          locationAddressWithLatLong: locationAddressWithLatLong,
          locationType: locationType,
        ),
      ]);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> updateFeedRadius({
    required double feedRadius,
    required LocationType locationType,
    bool fetchProfileSetting = false,
  }) async {
    try {
      await profileSettingsRepository.updateFeedRadius(
        feedRadius: feedRadius,
        locationType: locationType,
      );

      if (fetchProfileSetting) {
        //Update profile settings with the latest data
        await profileSettingsCubit.fetchProfileSettings();
      }

      if (isClosed) {
        return;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> updateLocation({
    required LocationAddressWithLatLng locationAddressWithLatLong,
    required LocationType locationType,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      await profileSettingsRepository.updateLocation(
        locationAddressWithLatLng: locationAddressWithLatLong,
        locationType: locationType,
      );
      await profileSettingsCubit.fetchProfileSettings();
      profileDetailsBloc.add(FetchProfileDetails());
      if (isClosed) {
        return;
      }
      emit(state.copyWith(requestSucceed: true));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}
