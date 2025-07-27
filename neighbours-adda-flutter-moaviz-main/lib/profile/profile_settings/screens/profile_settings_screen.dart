import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'dart:async';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/logic/remove_account/remove_account_cubit.dart';
import 'package:snap_local/profile/profile_settings/modules/reset_password/screen/reset_password_screen.dart.dart';
import 'package:snap_local/profile/profile_settings/utility/show_remove_account_dialog.dart';
import 'package:snap_local/profile/profile_settings/widgets/location_details_box.dart';
import 'package:snap_local/profile/profile_settings/widgets/map_and_feed_radius_widget_by_location_type.dart';
import 'package:snap_local/profile/profile_settings/widgets/profile_settings_container.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/default_location.dart';
import 'package:snap_local/utility/constant/url_links.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';

class ProfileSettingsScreen extends StatefulWidget {
  static const routeName = 'profile_settings';

  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late RadiusSliderRenderCubit radiusSliderCubit;
  late LocationRenderCubit locationRenderCubit;

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  Future<void> _renderLocationAndFeedRadius({
    required FeedRadiusModel feedRadiusModel,
    required LocationAddressWithLatLng? socialMediaLocationModel,
    required LocationAddressWithLatLng? marketPlaceLocationModel,
  }) async {
    //Wait for the widget tree to render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //tasks after widget tree render
      //emitting feedRadius data
      await radiusSliderCubit.emitRadius(feedRadiusModel);
      //emitting location data
      await locationRenderCubit.emitBothLocationType(
        socialMediaLocation: socialMediaLocationModel,
        marketPlaceLocation: marketPlaceLocationModel,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    //////
    locationRenderCubit = LocationRenderCubit();
    final profileSettingCubit = context.read<ProfileSettingsCubit>();
    final profileSettingState = profileSettingCubit.state;
    radiusSliderCubit = RadiusSliderRenderCubit();

    if (profileSettingState.isProfileSettingModelAvailable) {
      final feedRadiusModel =
          profileSettingState.profileSettingsModel!.feedRadiusModel;
      final socialMediaLocationModel =
          profileSettingState.profileSettingsModel!.socialMediaLocation;

      final marketPlaceLocationModel =
          profileSettingState.profileSettingsModel!.marketPlaceLocation;

      _renderLocationAndFeedRadius(
        feedRadiusModel: feedRadiusModel,
        socialMediaLocationModel: socialMediaLocationModel,
        marketPlaceLocationModel: marketPlaceLocationModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
      ],
      child: LanguageChangeBuilder(
        builder: (context, languageChangeState) {
          return Scaffold(
            appBar: ThemeAppBar(
              elevation: 2,
              backgroundColor: Colors.white,
              title: Text(
                tr(LocaleKeys.settings),
                style: TextStyle(color: ApplicationColours.themeBlueColor),
              ),
            ),
            body: BlocConsumer<ProfileSettingsCubit, ProfileSettingsState>(
              listener: (context, profileSettingState) {
                final profileSettingModel =
                    profileSettingState.profileSettingsModel;
                if (profileSettingModel != null) {
                  final feedRadiusModel = profileSettingModel.feedRadiusModel;

                  final socialMediaLocationModel =
                      profileSettingModel.socialMediaLocation;

                  final marketPlaceLocationModel =
                      profileSettingModel.marketPlaceLocation;

                  _renderLocationAndFeedRadius(
                    feedRadiusModel: feedRadiusModel,
                    socialMediaLocationModel: socialMediaLocationModel,
                    marketPlaceLocationModel: marketPlaceLocationModel,
                  );
                }
              },
              builder: (context, profileSettingState) {
                if (profileSettingState.error != null) {
                  return ErrorTextWidget(
                    error: profileSettingState.error!,
                    fontSize: 14,
                  );
                } else if (profileSettingState.dataLoading) {
                  return const ThemeSpinner(size: 40);
                } else {
                  final profileAccount = profileSettingState
                      .profileSettingsModel!.profileAccountDetails;
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    children: [
                      //////////////
                      //Social Media Location information
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ApplicationColours.themePinkColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            color: Colors.white,
                            child: BlocBuilder<LocationRenderCubit,
                                LocationRenderState>(
                              builder: (context, locationState) {
                                final location =
                                    locationState.socialMediaLocation;
                                final LatLng socialMediaCoordinates;
                                if (locationState
                                    .socialMediaLocationRenderStateAvailable) {
                                  socialMediaCoordinates = LatLng(
                                    location!.latitude,
                                    location.longitude,
                                  );
                                } else {
                                  socialMediaCoordinates = defaultLocation;
                                }

                                final socialMediaLocationAvailable =
                                    locationState
                                        .socialMediaLocationRenderStateAvailable;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MapAndFeedRadiusWidgetByLocationType(
                                      visible: socialMediaLocationAvailable,
                                      feedRadiusHeading:
                                          LocaleKeys.socialMediaLocation,
                                      feedRadiusDescription:
                                          LocaleKeys.feedSearchDescription,
                                      locationType: LocationType.socialMedia,
                                      selectedCoOdrinates:
                                          socialMediaCoordinates,
                                    ),
                                    LocationDetailsBox(
                                      padding: EdgeInsets.fromLTRB(
                                        10,
                                        socialMediaLocationAvailable ? 0 : 10,
                                        10,
                                        10,
                                      ),
                                      heading: socialMediaLocationAvailable
                                          ? null
                                          : LocaleKeys.socialMediaLocation,
                                      locationType: LocationType.socialMedia,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ApplicationColours.themePinkColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: // Your child widget here
                              //Market place lcoation information
                              BlocBuilder<LocationRenderCubit,
                                  LocationRenderState>(
                            builder: (context, locationState) {
                              final location =
                                  locationState.marketPlaceLocation;

                              LatLng? marketPlaceCoordinates;
                              if (locationState
                                  .marketPlaceLocationRenderStateAvailable) {
                                marketPlaceCoordinates = LatLng(
                                  location!.latitude,
                                  location.longitude,
                                );
                              } else {
                                marketPlaceCoordinates = defaultLocation;
                              }
                              final marketPlaceLocationAvailable = locationState
                                  .marketPlaceLocationRenderStateAvailable;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Market place lcoation information
                                  MapAndFeedRadiusWidgetByLocationType(
                                    visible: marketPlaceLocationAvailable,
                                    feedRadiusHeading:
                                        LocaleKeys.marketPlaceLocation,
                                    feedRadiusDescription:
                                        LocaleKeys.marketPlaceSearchDescription,
                                    locationType: LocationType.marketPlace,
                                    selectedCoOdrinates: marketPlaceCoordinates,
                                  ),
                                  LocationDetailsBox(
                                    padding: EdgeInsets.fromLTRB(
                                      10,
                                      marketPlaceLocationAvailable ? 0 : 10,
                                      10,
                                      10,
                                    ),
                                    heading: marketPlaceLocationAvailable
                                        ? null
                                        : LocaleKeys.marketPlaceLocation,
                                    locationType: LocationType.marketPlace,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      //////////////

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ProfileSettingContainer(
                          heading: LocaleKeys.account,
                          content: Column(
                            children: [
                              Visibility(
                                visible: profileAccount.mobile.isNotEmpty,
                                child: AccountDetailsWidget(
                                  label: tr(LocaleKeys.phoneNumber),
                                  value: profileAccount.mobile,
                                ),
                              ),
                              Visibility(
                                visible: profileAccount.email.isNotEmpty,
                                child: AccountDetailsWidget(
                                  label: tr(LocaleKeys.email),
                                  value: profileAccount.email,
                                  valueMaxLines: 2,
                                ),
                              ),
                              AccountDetailsWidget(
                                label: tr(LocaleKeys.password),
                                value: tr(LocaleKeys.resetPassword),
                                valueTextStyle: TextStyle(
                                  color: ApplicationColours.themeLightPinkColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                tapOnValue: () {
                                  GoRouter.of(context)
                                      .pushNamed(ResetPasswordScreen.routeName);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Commited as per the client requirement
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8),
                      //   child: ProfileSettingContainer(
                      //     heading: LocaleKeys.language,
                      //     content: Row(
                      //       children: [
                      //         SvgPicture.asset(SVGAssetsImages.languages),
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 4,
                      //           ),
                      //           child: Text(
                      //             languageChangeState.languagesModel.languages
                      //                 .firstWhere(
                      //                     (element) => element.isSelected)
                      //                 .languageEnum
                      //                 .englishName,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     buttonName: LocaleKeys.appLanguage,
                      //     buttonOnTap: () {
                      //       GoRouter.of(context).pushNamed(
                      //         ChooseLanguageScreen.routeName,
                      //         queryParameters: {'allow_pop': true.toString()},
                      //       );
                      //     },
                      //   ),
                      // ),

                      BlocBuilder<RemoveAccountCubit, RemoveAccountState>(
                        builder: (context, removeAccountState) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 8,
                              left: 15,
                              right: 15,
                            ),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: removeAccountState.isLoading
                                  ? null
                                  : () async {
                                      context
                                          .read<RemoveAccountCubit>()
                                          .resetState();
                                      showRemoveAccountDialog(
                                        context,
                                        phoneNumber: profileAccount.mobile,
                                      );
                                    },
                              child: Text(
                                tr(LocaleKeys.removeAccount),
                                style: const TextStyle(
                                  color: Color.fromRGBO(226, 33, 33, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "${tr(LocaleKeys.forHelpEmail)}: ",
                            style: const TextStyle(
                              color: Color.fromRGBO(3, 6, 32, 1),
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: supportEmail,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromRGBO(3, 6, 32, 1),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    UrlLauncher().sendEmail(
                                      email: supportEmail,
                                      subject: "Help",
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class AccountDetailsWidget extends StatelessWidget {
  final String label;
  final String value;
  final int valueMaxLines;
  final TextStyle? valueTextStyle;
  final void Function()? tapOnValue;
  const AccountDetailsWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueMaxLines = 1,
    this.valueTextStyle,
    this.tapOnValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(71, 70, 70, 0.6),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: tapOnValue,
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: valueMaxLines,
                overflow: TextOverflow.ellipsis,
                style: valueTextStyle ??
                    TextStyle(color: ApplicationColours.themeBlueColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
