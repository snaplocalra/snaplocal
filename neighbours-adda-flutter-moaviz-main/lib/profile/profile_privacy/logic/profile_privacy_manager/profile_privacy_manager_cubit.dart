import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_privacy/models/profile_privacy_model.dart';
import 'package:snap_local/profile/profile_privacy/repository/profile_privacy_repository.dart';

part 'profile_privacy_manager_state.dart';

class ProfilePrivacyManagerCubit extends Cubit<ProfilePrivacyManagerState> {
  final ProfilePrivacyRepository privacyRepository;
  ProfilePrivacyManagerCubit({
    required this.privacyRepository,
  }) : super(const ProfilePrivacyManagerState());

  Future<void> fetchPrivacySettings() async {
    try {
      if (state.isError || state.profilePrivacyModel == null) {
        emit(state.copyWith(dataLoading: true));
      }
      final privacySettings =
          await privacyRepository.fetchProfilePrivacySettings();
      emit(state.copyWith(profilePrivacyModel: privacySettings));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (!state.isProfilePrivacyModelAvailable) {
        emit(state.copyWith(error: e.toString()));
      } else {
        ThemeToast.errorToast(e.toString());
      }
    }
  }

  Future<void> updatePrivacySettings(
    ProfilePrivacyModel editedProfilePrivacyModel,
  ) async {
    try {
      await HapticFeedback.lightImpact();
      emit(state.copyWith(
        isRequestLoading: true,
        //emit the updated state to show the changes quickly
        profilePrivacyModel: editedProfilePrivacyModel,
      ));
      await privacyRepository.updateProfilePrivacy(editedProfilePrivacyModel);
      emit(state.copyWith());
      await privacyRepository.fetchProfilePrivacySettings();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith(isError: true));
    }
  }
}
