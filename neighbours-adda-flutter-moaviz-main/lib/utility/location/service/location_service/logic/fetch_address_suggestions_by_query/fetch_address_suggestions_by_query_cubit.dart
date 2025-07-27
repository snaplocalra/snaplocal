import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/location_helper_models/location_by_address.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

part 'fetch_address_suggestions_by_query_state.dart';

class FetchAddressSuggestionsByQueryCubit
    extends Cubit<FetchAddressSuggestionsByQueryState> {
  final LocationServiceRepository _locationServiceRepository;

  FetchAddressSuggestionsByQueryCubit(this._locationServiceRepository)
      : super(const FetchAddressSuggestionsByQueryState());

  Future<void> getAddressSuggestions(String query) async {
    try {
      // Show the loader
      emit(state.copyWith(
        isLoading: true,
        showBlankScreen: state.addressSugegstions.isEmpty,
      ));

      // Fetch the address suggestions
      final addressSugegstions = await makeIsolateApiCallWithInternetCheck(
        _locationServiceRepository.fetchAddressByQuery,
        query,
      );

      // Update the state
      emit(state.copyWith(addressSugegstions: addressSugegstions));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }

  Future<void> showLoader() async {
    emit(state.copyWith(isLoading: true));
  }

  Future<void> showBlankScreen() async {
    emit(state.copyWith(showBlankScreen: true));
  }
}
