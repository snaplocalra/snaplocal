// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/screens/search_location_screen.dart';
import 'package:snap_local/common/utils/location/widgets/google_map_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/constant/default_location.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

class TagLocationScreen extends StatefulWidget {
  final LocationAddressWithLatLng? preSelectedLocation;
  const TagLocationScreen({
    super.key,
    this.preSelectedLocation,
  });

  static const routeName = 'tag_location';

  @override
  State<TagLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<TagLocationScreen> {
//Google map controller
  GoogleMapController? googleMapController;

  //Timer to avoid repeated calls for location api
  Timer? timer;

  LatLng googleMapLocation = defaultLocation;
  TextEditingController locationController = TextEditingController();
  LocationAddressWithLatLng? userSelectedLocation;

  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  //This is to check whether the address is available or not. If the address is not there
  //show the static zoom on the map.
  bool isServerAddressAvailable = false;

  bool enableCameraIdleAction = false;

  Future<void> _setLocation(
      LocationAddressWithLatLng locationAddressWithLatLng) async {
    //Disable the camera idle action
    enableCameraIdleAction = false;

    //Reassign the user selected location
    userSelectedLocation = locationAddressWithLatLng;

    //Set the google map location
    _setGoogleMapLocation(
      latitude: userSelectedLocation!.latitude,
      longitude: userSelectedLocation!.longitude,
    );

    //Animate the camera to the selected location
    googleMapController
        ?.animateCamera(CameraUpdate.newLatLng(googleMapLocation));
  }

  void _setGoogleMapLocation({
    required double latitude,
    required double longitude,
  }) {
    googleMapLocation = LatLng(latitude, longitude);
  }

  @override
  void initState() {
    super.initState();

    final profileSettingsCubit = context.read<ProfileSettingsCubit>();
    final profileSettingsState = profileSettingsCubit.state;

    if (profileSettingsCubit.state.isProfileSettingModelAvailable) {
      LocationAddressWithLatLng? locationModel = widget.preSelectedLocation ??
          profileSettingsState.profileSettingsModel!.socialMediaLocation;

      if (locationModel != null) {
        isServerAddressAvailable = true;
        //Set the google map location
        _setLocation(locationModel);
      }
    } else {
      throw ("Profile data not available");
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    timer?.cancel();
    googleMapController?.dispose();
    super.dispose();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locationServiceControllerCubit),
      ],
      child: Builder(builder: (context) {
        return BlocListener<LocationServiceControllerCubit,
            LocationServiceControllerState>(
          listener: (context, locationServiceState) async {
            if (locationServiceState is LocationFetched) {
              isServerAddressAvailable = true;
              //Set the location
              await _setLocation(locationServiceState.location);
            } else if (locationServiceState is LocationError) {
              if (locationServiceState.locationPermanentDenied) {
                await showLocationPermissionPermanentDeniedHandlerDialog(
                    context);
              }
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              titleSpacing: 10,
              title: Text(
                tr(LocaleKeys.tagLocation),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 18,
                ),
              ),
            ),
            body: Column(
              children: [
                BlocBuilder<LocationServiceControllerCubit,
                    LocationServiceControllerState>(
                  builder: (context, locationServiceControllerState) {
                    return StatefulBuilder(builder: (context, searchBoxState) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                        child: ThemeTextFormField(
                          readOnly: true,
                          controller: locationController,
                          keyboardType: TextInputType.text,
                          fillColor: const Color.fromRGBO(249, 249, 249, 1),
                          hint: locationServiceControllerState ==
                                  LoadingLocation()
                              ? tr(LocaleKeys.fetchingLocation)
                              : tr(LocaleKeys.searchHere),
                          hintStyle: const TextStyle(fontSize: 15),
                          prefixIcon: const Icon(
                            FeatherIcons.search,
                            color: Color.fromRGBO(193, 193, 194, 1),
                          ),
                          onTap: locationServiceControllerState ==
                                  LoadingLocation()
                              ? null
                              : () async {
                                  await GoRouter.of(context)
                                      .pushNamed<LocationAddressWithLatLng>(
                                    SearchLocationScreen.routeName,
                                    extra: context
                                        .read<LocationServiceControllerCubit>(),
                                  )
                                      .then((selectedLocaton) {
                                    if (selectedLocaton != null) {
                                      //Set the location address
                                      locationController.text =
                                          selectedLocaton.address;
                                      //Set the location
                                      _setLocation(selectedLocaton);
                                    }
                                  });
                                },
                          suffixIcon: locationController.text.isEmpty
                              ? GestureDetector(
                                  onTap: locationServiceControllerState ==
                                          LoadingLocation()
                                      ? null
                                      : () {
                                          context
                                              .read<
                                                  LocationServiceControllerCubit>()
                                              .locationFetchByDeviceGPS();
                                        },
                                  child: Icon(
                                    Icons.gps_fixed,
                                    color: ApplicationColours.themeBlueColor,
                                    size: 20,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    locationController.clear();
                                    searchBoxState(() {});
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                        ),
                      );
                    });
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMapWidget(
                        onMapCreated: (controller) {
                          googleMapController = controller;
                        },
                        location: googleMapLocation,
                        zoomControlsEnabled: false,
                        zoom: 18,
                        staticZoom: !isServerAddressAvailable,
                        setInitialMarker: isServerAddressAvailable,
                        onCameraMove: (position) {
                          //Cancel the previous timer if the camera is moved
                          if (timer != null && timer!.isActive) {
                            timer!.cancel();
                          }
                          _setGoogleMapLocation(
                            latitude: position.target.latitude,
                            longitude: position.target.longitude,
                          );
                        },
                      ),

                      //Pointing the location
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AssetsImages.mapGreenMarker,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<LocationServiceControllerCubit,
                    LocationServiceControllerState>(
                  builder: (context, locationServiceControllerState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ThemeElevatedButton(
                        buttonName: tr(LocaleKeys.confirm),
                        disableButton:
                            locationServiceControllerState == LoadingLocation(),
                        showLoadingSpinner:
                            locationServiceControllerState == LoadingLocation(),
                        onPressed: () async {
                          await context
                              .read<LocationServiceControllerCubit>()
                              .locationFetchByLatLng(googleMapLocation)
                              .then((response) {
                            if (context.mounted) {
                              //On confirm pop with the selected location
                              GoRouter.of(context).pop(response);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
