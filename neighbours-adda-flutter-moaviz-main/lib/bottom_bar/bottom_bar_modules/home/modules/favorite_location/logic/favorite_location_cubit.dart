import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/model/favorite_location_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/repository/favorite_location_repository.dart';
import 'package:snap_local/common/utils/location/model/location_with_radius.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';

part 'favorite_location_state.dart';

class FavoriteLocationCubit extends Cubit<FavoriteLocationState> {
  final FavoriteLocationRepository favoriteLocationRepository;
  final ProfileSettingsCubit profileSettingsCubit;
  final ManageProfileDetailsBloc profileDetailsBloc;
  FavoriteLocationCubit({
    required this.favoriteLocationRepository,
    required this.profileSettingsCubit,
    required this.profileDetailsBloc,
  }) : super(const FavoriteLocationState());

  ///Fetch the profile settings and profile details to refresh the data
  Future<void> _refreshLocationOnProfile() async {
    //Fetch the profile settings and profile details to refresh the data
    await profileSettingsCubit.fetchProfileSettings();
    profileDetailsBloc.add(FetchProfileDetails());
  }

  Future<void> fetchFavLocationList({bool showLoading = false}) async {
    try {
      //If the favoriteLocationModel is null, then show the loading spinner
      if (showLoading ||
          (state.favoriteLocationModel == null ||
              state.favoriteLocationModel!.locationList.isEmpty)) {
        emit(state.copyWith(dataLoading: true));
      }
      final favLocationList =
          await favoriteLocationRepository.fetchFavLocationList();
      emit(state.copyWith(favoriteLocationModel: favLocationList));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(error: e.toString()));
    }
  }

  void addFavLocation(
    LocationWithPreferenceRadius locationWithPreferenceRadius,
  ) async {
    try {
      emit(state.copyWith(manageLocationLoading: true));
      await favoriteLocationRepository
          .addFavLocation(locationWithPreferenceRadius);
      await fetchFavLocationList();
      emit(state.copyWith(manageLocationSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  void updateFavLocation(
    FavLocationInfoModel favLocationInfoModel,
  ) async {
    try {
      emit(state.copyWith(manageLocationLoading: true));
      await favoriteLocationRepository.updateFavLocation(favLocationInfoModel);
      await fetchFavLocationList();

      //If the location is selected, then refresh the location on the profile to refresh the ui
      if (favLocationInfoModel.isSelected) {
        _refreshLocationOnProfile();
      }

      emit(state.copyWith(manageLocationSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  void deleteFavLocation(String locationId) async {
    try {
      emit(state.copyWith(deleteLocationLoading: true));
      await favoriteLocationRepository.deleteFavLocation(locationId);
      await fetchFavLocationList();
      emit(state.copyWith(deleteLocationSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> selectLocation(String locationId, int locationIndex) async {
    try {
      emit(state.copyWith(dataLoading: true));

      //Remove all selection
      state.favoriteLocationModel!.removeAllSelection();

      //Set the selected location to true
      state.favoriteLocationModel!.locationList[locationIndex].isSelected =
          true;

      //emit the state with the updated location list
      emit(state.copyWith());

      //Set the selected location to true
      await favoriteLocationRepository.setFavLocation(locationId);

      _refreshLocationOnProfile();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }
}
