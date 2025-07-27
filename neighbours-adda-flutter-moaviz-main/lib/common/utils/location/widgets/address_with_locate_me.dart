import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/tutorial_coach/shared_pref/tutorial_coach_shared_pref.dart';
import 'package:snap_local/common/utils/tutorial_coach/widgets/target_coach_widget.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/logic/update_profile_setting_location_and_feed_radius/update_profile_setting_location_and_feed_radius_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddressWithLocateMe extends StatefulWidget {
  final LocationType locationType;
  final double bottomPadding;
  final EdgeInsetsGeometry? contentMargin;
  final bool enableLocateMe;
  final double? height;
  final Color? backgroundColor;
  final Decoration? decoration;
  final double iconSize;
  final double iconTopPadding;
  final bool is3D;

  const AddressWithLocateMe({
    super.key,
    required this.locationType,
    this.bottomPadding = 5,
    this.contentMargin,
    this.enableLocateMe = false,
    //default colour white
    this.backgroundColor = Colors.white,
    this.height,
    this.decoration,
    this.iconSize = 20,
    this.iconTopPadding = 3,
    this.is3D = false,
  });

  @override
  State<AddressWithLocateMe> createState() => _AddressWithLocateMeState();
}

class _AddressWithLocateMeState extends State<AddressWithLocateMe> {
  late LocationRenderCubit locationRenderCubit;
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  late String buttonName = widget.locationType == LocationType.marketPlace
      ? tr(LocaleKeys.addMarketPlaceLocation)
      : tr(LocaleKeys.addSocialMediaLocation);

  void emitLocation(ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      final profileSettingModel = profileSettingsState.profileSettingsModel!;

      final locationModel = widget.locationType == LocationType.socialMedia
          ? profileSettingModel.socialMediaLocation
          : profileSettingModel.marketPlaceLocation;

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (locationModel == null) {
            //Show location add tutorial
            initTutorialCoach();
          }

          //emitting location data
          locationRenderCubit.emitLocation(
            locationAddressWithLatLong: locationModel,
            locationType: widget.locationType,
          );
        },
      );
    }
  }

  ///Tutorial coach
  GlobalKey addLocationButtonKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  void showTutorial() {
    if (mounted) {
      tutorialCoachMark.show(context: context);
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      hideSkip: true,
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "add_location_button_key",
        keyTarget: addLocationButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TargetCoachWidget(
                tutorialCoachMark: tutorialCoachMark,
                title: "Click here to $buttonName",
                nextText: "OK",
                onNext: () async {
                  tutorialCoachMark.finish();
                },
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  void initTutorialCoach() {
    Future.delayed(Duration.zero, () async {
      if (!await TutorialCoachSharedPref().isAddLocationCoachCompleted()) {
        showTutorial();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //Tutorial coach initialization
    createTutorial();

    final profileSettingsCubit = context.read<ProfileSettingsCubit>();
    final profileSettingsState = profileSettingsCubit.state;
    locationRenderCubit = LocationRenderCubit();
    emitLocation(profileSettingsState);
  }

  @override
  void dispose() {
    tutorialCoachMark.finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSettingsCubit, ProfileSettingsState>(
      listener: (context, profileSettingsState) {
        emitLocation(profileSettingsState);
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: locationRenderCubit),
          BlocProvider.value(value: locationServiceControllerCubit),
        ],
        child: BlocBuilder<LocationRenderCubit, LocationRenderState>(
          builder: (context, locationRenderState) {
            final showLoading = !locationRenderState.isDataLoaded;
            final locationAvailable = widget.locationType ==
                    LocationType.marketPlace
                ? locationRenderState.marketPlaceLocationRenderStateAvailable
                : locationRenderState.socialMediaLocationRenderStateAvailable;

            return Container(
              decoration: locationAvailable && widget.is3D
                  ? const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(195, 208, 248, 1),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(
                              0, 3), // changes the position of the shadow
                        ),
                      ],
                    )
                  : null,
              child: Container(
                height: widget.height,
                color: widget.backgroundColor,
                decoration: locationAvailable ? widget.decoration : null,
                margin:
                    widget.contentMargin ?? const EdgeInsets.only(bottom: 5),
                child: showLoading
                    ? const ThemeSpinner(size: 35)
                    : locationAvailable
                        ? BlocConsumer<LocationServiceControllerCubit,
                            LocationServiceControllerState>(
                            listener:
                                (context, locationServiceControllerState) {
                              if (locationServiceControllerState
                                  is LocationFetched) {
                                final newLocation =
                                    locationServiceControllerState.location;
                                //emitting location data
                                locationRenderCubit.emitLocation(
                                  locationAddressWithLatLong: newLocation,
                                  locationType: widget.locationType,
                                );
                                context
                                    .read<
                                        UpdateProfileSettingLocationAndFeedRadiusCubit>()
                                    .updateLocation(
                                      locationAddressWithLatLong: newLocation,
                                      locationType: widget.locationType,
                                    );
                              }
                            },
                            builder: (context, locationServiceControllerState) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: locationServiceControllerState ==
                                                LoadingLocation()
                                            ? null
                                            : () {
                                              print('Navigating to map screen');
                                              print(widget.locationType);
                                              print(LocationManageType.setting);
                                                GoRouter.of(context).pushNamed(
                                                  LocationManageMapScreen
                                                      .routeName,
                                                  extra: {
                                                    "locationType":
                                                        widget.locationType,
                                                    "locationManageType":
                                                        LocationManageType
                                                            .setting,
                                                  },
                                                );
                                              },
                                        child: AbsorbPointer(
                                          child: AddressWithLocationIconWidget(
                                            iconSize: widget.iconSize,
                                            iconTopPadding:
                                                widget.iconTopPadding,
                                            fontSize: 11,
                                            address:
                                                locationServiceControllerState ==
                                                        LoadingLocation()
                                                    ? "Loading..."
                                                    : widget.locationType ==
                                                            LocationType
                                                                .marketPlace
                                                        ? locationRenderState
                                                            .marketPlaceLocation!
                                                            .address
                                                        : locationRenderState
                                                            .socialMediaLocation!
                                                            .address,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //Locate me button
                                    widget.enableLocateMe
                                        ? GestureDetector(
                                            onTap:
                                                locationServiceControllerState ==
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
                                              size: 16,
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                    // LocateMeButton(
                                    //   backgroundColor:
                                    //       const Color.fromRGBO(
                                    //           244, 243, 243, 1),
                                    //   onLocateMe:
                                    //       locationServiceControllerState ==
                                    //               LoadingLocation()
                                    //           ? null
                                    //           : () {
                                    //               context
                                    //                   .read<
                                    //                       LocationServiceControllerCubit>()
                                    //                   .locationFetchByDeviceGPS();
                                    //             },
                                    // ),
                                  ],
                                ),
                              );
                            },
                          )
                        :
                        //Add location
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ThemeElevatedButton(
                              key: addLocationButtonKey,
                              onPressed: () async {
                                await TutorialCoachSharedPref()
                                    .setAddLocationCoachComplete()
                                    .whenComplete(() {
                                  GoRouter.of(context).pushNamed(
                                    LocationManageMapScreen.routeName,
                                    extra: {
                                      "locationType": widget.locationType,
                                      "locationManageType":
                                          LocationManageType.setting,
                                    },
                                  );
                                });
                              },
                              padding: EdgeInsets.zero,
                              buttonName: buttonName,
                              textFontSize: 10,
                              backgroundColor:
                                  ApplicationColours.themeLightPinkColor,
                              height: 35,
                            ),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}
