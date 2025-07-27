import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/logic/favorite_location_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/model/favorite_location_model.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class FavoriteLocationCard extends StatelessWidget {
  const FavoriteLocationCard({
    super.key,
    required this.addressModel,
    required this.selectedRadioIndex,
    required this.objectIndex,
    this.onTap,
  });

  final FavLocationInfoModel addressModel;
  final int? selectedRadioIndex;
  final int objectIndex;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color selectedColorWithOpacity =
        ApplicationColours.themeBlueColor.withOpacity(0.1);
    Color unselectedColor = Colors.white;
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          tileColor: addressModel.isSelected
              ? selectedColorWithOpacity
              : unselectedColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          leading: SvgPicture.asset(
            SVGAssetsImages.homeFavLocate,
            height: 20,
            width: 20,
          ),
          title: Transform.translate(
            offset: const Offset(-20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  addressModel.locationWithPreferenceRadius.location.address,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${tr(LocaleKeys.selectedRadius)}: ${addressModel.locationWithPreferenceRadius.preferredRadius.formatNumber()} km",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          LocationManageMapScreen.routeName,
                          extra: {
                            "locationType": LocationType.socialMedia,
                            "locationManageType": LocationManageType.favorite,
                            "favLocationInfoModel": addressModel
                          },
                        );
                      },
                      child: Text(
                        tr(LocaleKeys.edit),
                        style: const TextStyle(
                          color: Color(0xffc80981),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    //Vertical divider
                    const SizedBox(
                      height: 10,
                      child: VerticalDivider(
                        thickness: 1.5,
                        color: Color(0xffc80981),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => BlocConsumer<
                              FavoriteLocationCubit, FavoriteLocationState>(
                            listener: (context, favoriteLocationState) {
                              if (favoriteLocationState.deleteLocationSuccess) {
                                Navigator.pop(dialogContext);
                              }
                            },
                            builder: (context, favoriteLocationState) {
                              return AlertDialog.adaptive(
                                title: Text(tr(LocaleKeys.deleteLocation)),
                                content: Text(
                                  // "Are you sure you want to delete this location?",
                                  tr(LocaleKeys.areYouSureToDeleteThisLocation),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: favoriteLocationState
                                              .deleteLocationLoading
                                          ? null
                                          : () {
                                              Navigator.pop(dialogContext);
                                            },
                                      child: Text(
                                        tr(LocaleKeys.cancel),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  TextButton(
                                    onPressed: favoriteLocationState
                                            .deleteLocationLoading
                                        ? null
                                        : () {
                                            context
                                                .read<FavoriteLocationCubit>()
                                                .deleteFavLocation(
                                                  addressModel.id,
                                                );
                                          },
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: favoriteLocationState
                                              .deleteLocationLoading
                                          ? const ThemeSpinner(
                                              size: 25,
                                              height: 25,
                                              width: 25,
                                            )
                                          : Text(
                                              tr(LocaleKeys.delete),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        tr(LocaleKeys.delete),
                        style: const TextStyle(
                          color: Color(0xffc80981),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: Radio<int>(
            value: objectIndex,
            groupValue: selectedRadioIndex,
            onChanged: (selectedIndex) {
              context
                  .read<FavoriteLocationCubit>()
                  .selectLocation(addressModel.id, selectedIndex!);
            },
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }
}
