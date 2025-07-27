import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/logic/favorite_location_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/widgets/favorite_location_card.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class FavoriteLocationScreen extends StatefulWidget {
  const FavoriteLocationScreen({super.key});

  static const routeName = 'favorite_location';

  @override
  State<FavoriteLocationScreen> createState() => _FavoriteLocationScreenState();
}

class _FavoriteLocationScreenState extends State<FavoriteLocationScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<FavoriteLocationCubit>()
        .fetchFavLocationList(showLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ThemeAppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.favoriteLocation),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircularSvgButton(
              backgroundColor: const Color.fromRGBO(238, 242, 255, 1),
              borderColor: const Color.fromRGBO(238, 242, 255, 1),
              iconSize: 15,
              iconColor: ApplicationColours.themeBlueColor,
              svgImage: SVGAssetsImages.addIcon,
              onTap: () {
                GoRouter.of(context).pushNamed(
                  LocationManageMapScreen.routeName,
                  extra: {
                    "locationType": LocationType.socialMedia,
                    "locationManageType": LocationManageType.favorite,
                  },
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<FavoriteLocationCubit, FavoriteLocationState>(
        builder: (context, favLocationState) {
          if (favLocationState.error != null) {
            return ErrorTextWidget(error: favLocationState.error!);
          } else if (favLocationState.dataLoading) {
            return const Center(child: ThemeSpinner());
          } else {
            final logs = favLocationState.favoriteLocationModel!.locationList;

            if (logs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SVGAssetsImages.homeFavLocate,
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tr(LocaleKeys.noFavoriteLocations),
                      style: const TextStyle(color: Color(0xff001968)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ThemeElevatedButton(
                        buttonName: tr(LocaleKeys.addLocation),
                        showLoadingSpinner: false,
                        disableButton: false,
                        onPressed: () {
                          GoRouter.of(context).pushNamed(
                            LocationManageMapScreen.routeName,
                            extra: {
                              "locationType": LocationType.socialMedia,
                              "locationManageType": LocationManageType.favorite,
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final logs = favLocationState.favoriteLocationModel!.locationList;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: logs.length,
                itemBuilder: (BuildContext context, int index) {
                  // get the address model
                  final addressModel = logs[index];

                  // set the selected index as the selected radio
                  final selectedRadio = addressModel.isSelected ? index : null;

                  return FavoriteLocationCard(
                    addressModel: addressModel,
                    selectedRadioIndex: selectedRadio,
                    objectIndex: index,
                    onTap: () {
                      context
                          .read<FavoriteLocationCubit>()
                          .selectLocation(addressModel.id, index);

                      //close the screen
                      GoRouter.of(context).pop();
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
