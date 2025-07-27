// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/logic/favorite_location_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/model/favorite_location_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/logic/sales_post/sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/repository/sales_post_repository.dart';
import 'package:snap_local/common/utils/location/helper/calculate_zoom_from_radius.dart';
import 'package:snap_local/common/utils/location/logic/asset_marker_creator/asset_marker_creator_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_with_radius.dart';
import 'package:snap_local/common/utils/location/screens/search_location_screen.dart';
import 'package:snap_local/common/utils/location/widgets/google_map_widget.dart';
import 'package:snap_local/common/utils/location/widgets/radius_slider.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/logic/update_profile_setting_location_and_feed_radius/update_profile_setting_location_and_feed_radius_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/constant/default_location.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

class LocationManageMapScreen extends StatefulWidget {
  final bool allowPop;
  final LocationType locationType;
  final LocationManageType locationManageType;
  final FavLocationInfoModel? favLocationInfoModel;

  const LocationManageMapScreen({
    super.key,
    required this.allowPop,
    required this.locationType,
    required this.locationManageType,
    this.favLocationInfoModel,
  });

  static const routeName = 'location_manage_map_screen';

  @override
  State<LocationManageMapScreen> createState() =>
      _LocationManageMapScreenState();
}

class _LocationManageMapScreenState extends State<LocationManageMapScreen> {
  TextEditingController locationController = TextEditingController();

  GoogleMapController? mapController;

  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  late RadiusSliderRenderCubit radiusSliderRenderCubit =
      RadiusSliderRenderCubit();

  final assetMarkerCreatorCubit = AssetMarkerCreatorCubit();

  //Default location address with lat long
  LocationAddressWithLatLng userSelectedLocation =
      defaultLocationAddressWithLatLng;

  //Default location
  LatLng googleMapLocation = defaultLocation;

  // Default circle radius
  double circleRadius = 0;

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  Future<void> _setLocation(
      LocationAddressWithLatLng locationAddressWithLatLng) async {
    //Assign the location to the user selected location
    userSelectedLocation = locationAddressWithLatLng;

    //Assign the location to the google map location
    googleMapLocation = userSelectedLocation.toLatLng();

    //create marker
    await assetMarkerCreatorCubit.createAssetMarker(
      selectedLocation: userSelectedLocation.toLatLng(),
      assetImageMapMarker: AssetsImages.mapGreenMarker,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Delay the map camera movement to allow the map to be created,
      //this is to prevent the map controller from being null and not moving the camera
      Future.delayed(Duration(seconds: mapController == null ? 2 : 0), () {
        //Move map camera to the selected location
        mapController?.animateCamera(
          CameraUpdate.newLatLng(googleMapLocation),
        );
      });
    });
  }

  Future<void> _renderFeedRadius({
    required FeedRadiusModel feedRadiusModel,
  }) async {
    //emitting feedRadius data
    await radiusSliderRenderCubit.emitRadius(feedRadiusModel);

    //Set the map zoom by radius
    await _setMapZoomByRadius();
  }

  Future<void> _setMapZoomByRadius() async {
    final radius = radiusSliderRenderCubit.state.feedRadiusModel
        .radiusByLocationType(widget.locationType);

    //Assign the circle radius
    circleRadius = (radius.toDouble() * 1000);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Delay the map camera movement to allow the map to be created,
      //this is to prevent the map controller from being null and not moving the camera
      Future.delayed(Duration(seconds: mapController == null ? 2 : 0), () {
        //Move map camera to the selected location
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            googleMapLocation,
            calculateZoomLevel(circleRadius),
          ),
        );
      });
    });
  }

  String get appBarTitle {
    if (widget.locationManageType == LocationManageType.setting) {
      return "${tr(LocaleKeys.update)} ${tr(widget.locationType.displayName)} ${tr(LocaleKeys.location)}";
    } else if (widget.locationManageType == LocationManageType.favorite) {
      return "${widget.favLocationInfoModel != null ? tr(LocaleKeys.update) : tr(LocaleKeys.add)} ${tr(LocaleKeys.favoriteLocation)}";
    }
    throw ("Location manage type not available");
  }

  @override
  void initState() {
    super.initState();

    final profileSettingsCubit = context.read<ProfileSettingsCubit>();
    final profileSettingsState = profileSettingsCubit.state;

    if (profileSettingsCubit.state.isProfileSettingModelAvailable) {
      //location model
      LocationAddressWithLatLng? locationModel;

      //feed radius model
      FeedRadiusModel feedRadiusModel =
          profileSettingsState.profileSettingsModel!.feedRadiusModel;

      //Manage the LocationWithPreferenceRadius model//
      if (widget.favLocationInfoModel != null) {
        //Assign the location model
        locationModel =
            widget.favLocationInfoModel!.locationWithPreferenceRadius.location;

        if (widget.locationType == LocationType.socialMedia) {
          feedRadiusModel = feedRadiusModel.copyWith(
            socialMediaSearchRadius: widget.favLocationInfoModel!
                .locationWithPreferenceRadius.preferredRadius,
          );
        } else if (widget.locationType == LocationType.marketPlace) {
          feedRadiusModel = feedRadiusModel.copyWith(
            marketPlaceSearchRadius: widget.favLocationInfoModel!
                .locationWithPreferenceRadius.preferredRadius,
          );
        } else {
          throw ("Location type not available");
        }
      } else {
        if (widget.locationType == LocationType.socialMedia) {
          locationModel =
              profileSettingsState.profileSettingsModel!.socialMediaLocation;
        } else {
          locationModel =
              profileSettingsState.profileSettingsModel!.marketPlaceLocation;
        }
      }

      //Check if the location is available on the profile setting
      Future.delayed(Duration.zero, () async {
        if (locationModel != null) {
          await _setLocation(locationModel);
        } else {
          await _setLocation(defaultLocationAddressWithLatLng);
          //If the address is not available on the profile setting then, fetch the address using the GPS
          //Fetch the location using the GPS
          locationServiceControllerCubit.locationFetchByDeviceGPS();
        }
        //emitting radius data
        await _renderFeedRadius(feedRadiusModel: feedRadiusModel);
      });
    } else {
      throw ("Profile data not available");
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  bool requestLoading = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: radiusSliderRenderCubit),
        BlocProvider(
          create: (context) => SalesPostCubit(
            SalesPostRepository(), // Create repository instance
          ),
        ),
      ],
      child: BlocConsumer<FavoriteLocationCubit, FavoriteLocationState>(
        listener: (context, favoriteLocationState) {
          if (favoriteLocationState.manageLocationSuccess && mounted) {
            try {
              print('POPPING 1');
              GoRouter.of(context).pop();
              return;
            } catch (e) {
              // Record the error in Firebase Crashlytics
              FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
              return;
            }
          }
        },
        builder: (context, favoriteLocationState) {
          //Assigning the requestLoading value if the favorite location is loading
          if (favoriteLocationState.manageLocationLoading) {
            requestLoading = favoriteLocationState.manageLocationLoading;
          }

          return BlocConsumer<UpdateProfileSettingLocationAndFeedRadiusCubit,
              UpdateProfileSettingLocationState>(
            listener: (context, locationUpdateState) {
              if (locationUpdateState.requestSucceed && mounted) {
                try {
                  print('POPPING 2');
                  GoRouter.of(context).pop();
                  return;
                } catch (e) {
                  // Record the error in Firebase Crashlytics
                  FirebaseCrashlytics.instance
                      .recordError(e, StackTrace.current);
                  return;
                }
              }
            },
            builder: (context, locationUpdateState) {
              //Assigning the requestLoading value if the location update is loading
              if (locationUpdateState.isLoading) {
                requestLoading = locationUpdateState.isLoading;
              }

              return BlocConsumer<ProfileSettingsCubit, ProfileSettingsState>(
                listener: (context, profileSettingState) {
                  if (profileSettingState.isProfileSettingModelAvailable) {
                    final feedRadiusModel = profileSettingState
                        .profileSettingsModel!.feedRadiusModel;

                    LocationAddressWithLatLng? locationModel;

                    if (widget.locationType == LocationType.socialMedia) {
                      locationModel = profileSettingState
                          .profileSettingsModel!.socialMediaLocation;
                    } else {
                      locationModel = profileSettingState
                          .profileSettingsModel!.marketPlaceLocation;
                    }
                    if (locationModel != null) {
                      _setLocation(locationModel);
                      _renderFeedRadius(
                        feedRadiusModel: feedRadiusModel,
                      );
                    }
                  }
                },
                builder: (context, profileSettingState) {
                  return BlocConsumer<LocationServiceControllerCubit,
                      LocationServiceControllerState>(
                    listener: (context, locationServiceState) async {
                      if (locationServiceState is LocationFetched) {
                        _setLocation(locationServiceState.location);
                      } else if (locationServiceState is LocationError) {
                        if (locationServiceState.locationPermanentDenied) {
                          await showLocationPermissionPermanentDeniedHandlerDialog(
                              context);
                        }
                      }
                    },
                    builder: (context, locationServiceState) {
                      return PopScope(
                        canPop:
                            willPopScope(widget.allowPop && !requestLoading),
                        child: Scaffold(
                          backgroundColor: Colors.white,
                          appBar: ThemeAppBar(
                            backgroundColor: Colors.white,
                            showBackButton: widget.allowPop,
                            onPop: () async => willPopScope(
                                widget.allowPop && !requestLoading),
                            titleSpacing: widget.allowPop ? 0 : 10,
                            title: Text(
                              appBarTitle,
                              style: TextStyle(
                                color: ApplicationColours.themeBlueColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatefulBuilder(
                                  builder: (context, searchBoxState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ThemeTextFormField(
                                    readOnly: true,
                                    controller: locationController,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 14),
                                    fillColor:
                                        const Color.fromRGBO(249, 249, 249, 1),
                                    hint: locationServiceState ==
                                            LoadingLocation()
                                        ? tr(LocaleKeys.fetchingLocation)
                                        : tr(LocaleKeys.searchHere),
                                    hintStyle: const TextStyle(fontSize: 14),
                                    prefixIcon: const Icon(
                                      FeatherIcons.search,
                                      color: Color.fromRGBO(193, 193, 194, 1),
                                    ),
                                    onTap: locationServiceState ==
                                            LoadingLocation()
                                        ? null
                                        : () async {
                                            await GoRouter.of(context)
                                                .pushNamed<
                                                    LocationAddressWithLatLng>(
                                              SearchLocationScreen.routeName,
                                              extra: context.read<
                                                  LocationServiceControllerCubit>(),
                                            )
                                                .then((selectedLocaton) {
                                              if (selectedLocaton != null) {
                                                locationController.text =
                                                    selectedLocaton.address;
                                                _setLocation(selectedLocaton);
                                              }
                                            });
                                          },
                                    suffixIcon: locationController.text.isEmpty
                                        ? GestureDetector(
                                            onTap: locationServiceState ==
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
                                              color: ApplicationColours
                                                  .themeBlueColor,
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
                              }),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: BlocBuilder<RadiusSliderRenderCubit,
                                      RadiusSliderRenderState>(
                                    builder: (context, radiusSliderState) {
                                      final maxRadius = radiusSliderState
                                          .feedRadiusModel
                                          .maxSearchVisibilityRadius;

                                      return Stack(
                                        children: [
                                          BlocBuilder<AssetMarkerCreatorCubit,
                                              AssetMarkerCreatorState>(
                                            bloc: assetMarkerCreatorCubit,
                                            builder: (context,
                                                assetMarkerCreatorState) {
                                              return GoogleMapWidget(
                                                key: const ValueKey(
                                                    "google_map"),
                                                onMapCreated: (controller) {
                                                  mapController = controller;
                                                },
                                                location: googleMapLocation,
                                                zoomControlsEnabled: false,
                                                markers: assetMarkerCreatorState
                                                    .markers,
                                                circleRadius: circleRadius,
                                                circles: {
                                                  Circle(
                                                    circleId: const CircleId(
                                                        "feed_radius"),
                                                    center: googleMapLocation,
                                                    strokeWidth: 2,
                                                    strokeColor:
                                                        const Color.fromRGBO(
                                                      241,
                                                      170,
                                                      170,
                                                      1,
                                                    ),
                                                    fillColor:
                                                        const Color.fromRGBO(
                                                      241,
                                                      170,
                                                      170,
                                                      0.4,
                                                    ),
                                                    radius: circleRadius,
                                                  )
                                                },
                                                staticZoom: false,
                                                zoom: 5,
                                                setInitialMarker: true,
                                              );
                                            },
                                          ),
                                          Visibility(
                                            visible: locationServiceState ==
                                                LoadingLocation(),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              child: const ThemeSpinner(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (profileSettingState
                                              .isProfileSettingModelAvailable)
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .only(
                                                    topStart:
                                                        Radius.circular(20),
                                                    topEnd: Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              left: 20),
                                                      child: Text(
                                                        // tr(LocaleKeys
                                                        //     .setRadius),
                                                        'SET RADIUS',
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromRGBO(
                                                              71, 70, 70, 1),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: RadiusSlider(
                                                        maxRadius: maxRadius,
                                                        onRadiusChanged:
                                                            (value) {
                                                          late FeedRadiusModel
                                                              updatedFeedRadiusModel;

                                                          if (widget
                                                                  .locationType ==
                                                              LocationType
                                                                  .socialMedia) {
                                                            updatedFeedRadiusModel =
                                                                radiusSliderState
                                                                    .feedRadiusModel
                                                                    .copyWith(
                                                              socialMediaSearchRadius:
                                                                  value,
                                                            );
                                                          } else {
                                                            updatedFeedRadiusModel =
                                                                radiusSliderState
                                                                    .feedRadiusModel
                                                                    .copyWith(
                                                              marketPlaceSearchRadius:
                                                                  value,
                                                            );
                                                          }

                                                          // render the feed radius
                                                          _renderFeedRadius(
                                                              feedRadiusModel:
                                                                  updatedFeedRadiusModel);
                                                        },
                                                        userSelectedRadius:
                                                            radiusSliderState
                                                                .feedRadiusModel
                                                                .radiusByLocationType(
                                                                    widget
                                                                        .locationType),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          20, 20, 20, 5),
                                                      child:
                                                          ThemeElevatedButton(
                                                        buttonName:
                                                            tr(LocaleKeys.save),
                                                        disableButton:
                                                            locationServiceState ==
                                                                LoadingLocation(),
                                                        showLoadingSpinner:
                                                            requestLoading,
                                                        onPressed: () async {
                                                          print(
                                                              'Save Button Tapped');
                                                          final radiusSliderRenderModel =
                                                              context
                                                                  .read<
                                                                      RadiusSliderRenderCubit>()
                                                                  .state
                                                                  .feedRadiusModel;
                                                          late double
                                                              updatedRadius;

                                                          print(
                                                              'Radius: ${radiusSliderRenderModel.radiusByLocationType(widget.locationType)}');
                                                          print(
                                                              'Location Type: ${widget.locationType}');
                                                          // return;
                                                          //Assign the updated radius based on the location type
                                                          if (widget
                                                                  .locationType ==
                                                              LocationType
                                                                  .socialMedia) {
                                                            print('HELLO 01');
                                                            updatedRadius =
                                                                radiusSliderRenderModel
                                                                    .socialMediaSearchRadius;
                                                          } else {
                                                            print('HELLO 02');
                                                            updatedRadius =
                                                                radiusSliderRenderModel
                                                                    .marketPlaceSearchRadius;
                                                          }
                                                          //

                                                          //Update location and feed radius on the settings
                                                          if (widget
                                                                  .locationManageType ==
                                                              LocationManageType
                                                                  .setting) {
                                                            print('HELLO 03');
                                                            //Update location and feed radius on the settings
                                                            await context
                                                                .read<
                                                                    UpdateProfileSettingLocationAndFeedRadiusCubit>()
                                                                .updateLocationWithFeedRadius(
                                                                  locationAddressWithLatLong:
                                                                      userSelectedLocation,
                                                                  feedRadius:
                                                                      updatedRadius,
                                                                  locationType:
                                                                      widget
                                                                          .locationType,
                                                                );
                                                          }

                                                          //Update location and feed radius on the favorite
                                                          else if (widget
                                                                  .locationManageType ==
                                                              LocationManageType
                                                                  .favorite) {
                                                            print('HELLO 04');
                                                            if (widget
                                                                    .locationManageType ==
                                                                LocationManageType
                                                                    .favorite) {
                                                              //Create the location with preference radius object
                                                              final locationWithPreferenceRadius =
                                                                  LocationWithPreferenceRadius(
                                                                location:
                                                                    userSelectedLocation,
                                                                preferredRadius:
                                                                    updatedRadius,
                                                              );

                                                              if (widget
                                                                      .favLocationInfoModel !=
                                                                  null) {
                                                                print(
                                                                    'HELLO 05');
                                                                //Update location
                                                                context
                                                                    .read<
                                                                        FavoriteLocationCubit>()
                                                                    .updateFavLocation(widget
                                                                        .favLocationInfoModel!
                                                                        .copyWith(
                                                                      locationWithPreferenceRadius:
                                                                          locationWithPreferenceRadius,
                                                                    ));
                                                              } else {
                                                                //Insert location
                                                                print(
                                                                    'HELLO 06');
                                                                //API call to add the location to the favorite
                                                                context
                                                                    .read<
                                                                        FavoriteLocationCubit>()
                                                                    .addFavLocation(
                                                                      locationWithPreferenceRadius,
                                                                    );
                                                              }
                                                            }
                                                          }
                                                          print('HELLO 07');

                                                          if(mounted) {
                                                            //Pop the screen
                                                            // GoRouter.of(context)
                                                            //     .pop();
                                                            context
                                                              .read<
                                                                  SalesPostCubit>()
                                                              .fetchSalesPost();
                                                          }
                                                          
                                                        
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
