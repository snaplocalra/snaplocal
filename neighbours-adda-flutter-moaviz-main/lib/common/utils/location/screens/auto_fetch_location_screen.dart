import 'package:designer/widgets/loading_screen.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/logic/update_profile_setting_location_and_feed_radius/update_profile_setting_location_and_feed_radius_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

class AudoFetchCurrentLocationScreen extends StatefulWidget {
  const AudoFetchCurrentLocationScreen({super.key});

  @override
  State<AudoFetchCurrentLocationScreen> createState() =>
      _AudoFetchCurrentLocationScreenState();
}

class _AudoFetchCurrentLocationScreenState
    extends State<AudoFetchCurrentLocationScreen> {
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>())
        ..locationFetchByDeviceGPS();

  @override
  void initState() {
    super.initState();

    final profileSettingsCubit = context.read<ProfileSettingsCubit>();
    final profileSettingsState = profileSettingsCubit.state;

    if (profileSettingsCubit.state.isProfileSettingModelAvailable) {
      //feed radius model
      late FeedRadiusModel feedRadiusModel;
      feedRadiusModel =
          profileSettingsState.profileSettingsModel!.feedRadiusModel;

      locationServiceControllerCubit.stream.listen(
        (locationState) async {
          if (locationState is LocationFetched) {
            final location = locationState.location;
            //update the location
            if (mounted) {
              context
                  .read<UpdateProfileSettingLocationAndFeedRadiusCubit>()
                  .updateLocationWithFeedRadius(
                    locationAddressWithLatLong: location,
                    feedRadius: feedRadiusModel.socialMediaSearchRadius,
                    locationType: LocationType.socialMedia,
                  );
            }
          } else if (locationState is LocationError) {
            if (locationState.locationPermanentDenied && mounted) {
              await showLocationPermissionPermanentDeniedHandlerDialog(context);
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: locationServiceControllerCubit,
        child: BlocBuilder<LocationServiceControllerCubit,
            LocationServiceControllerState>(
          builder: (context, locationState) {
            if (locationState is LocationError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorTextWidget(
                    error: locationState.error,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 5),
                  ThemeElevatedButton(
                    buttonName: tr(LocaleKeys.retry),
                    textFontSize: 12,
                    width: 120,
                    height: 40,
                    onPressed: () {
                      locationServiceControllerCubit.locationFetchByDeviceGPS();
                    },
                  ),
                ],
              );
            }

            return const LoadingScreen(
                waitingText: "Fetching current location");
          },
        ),
      ),
    );
  }
}
