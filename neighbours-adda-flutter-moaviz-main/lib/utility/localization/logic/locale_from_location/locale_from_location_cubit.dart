import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

part 'locale_from_location_state.dart';

class LocaleFromLocationCubit extends Cubit<LocaleFromLocationState> {
  final LocationServiceRepository locationServiceRepository;
  LocaleFromLocationCubit(this.locationServiceRepository)
      : super(LocaleFromLocationInitial());

  Locale _getLocaleFromAddress(
    String stateName,
    Locale defaultLocale,
  ) {
    switch (stateName.toLowerCase()) {
      // Andhra Pradesh, Teleangana
      case "ap":
      case "ts":
        return LocaleManager.telugu;

      // Karnataka
      case "ka":
        return LocaleManager.kannada;

      // Kerala
      case "kl":
        return LocaleManager.malayalam;

      // Tamil Nadu
      case "tn":
        return LocaleManager.tamil;

      default:
        return defaultLocale;
    }
  }

  Future<void> getLocaleByLocation({required Locale defaultLocale}) async {
    try {
      emit(LoadingLocaleFromLocation());

      //If the GPS permission is granted then proceed
      //This is to not ask for permission when opening the app
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final location =
            await locationServiceRepository.fetchAddressByGPSPosition();

        if (location == null) {
          return emit(const LocaleFromLocationError(
            errorMessage: 'Location not found',
          ));
        } else {
          final locale = _getLocaleFromAddress(
            location.address.split(',').last,
            defaultLocale,
          );
          emit(LocaleFromLocationLoaded(locale: locale));
        }
      }
    } catch (e) {
      return emit(LocaleFromLocationError(errorMessage: e.toString()));
    }
  }
}
