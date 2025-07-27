import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/profile/profile_settings/widgets/profile_settings_container.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class LocationDetailsBox extends StatelessWidget {
  final String? heading;
  final LocationType locationType;
  final EdgeInsetsGeometry? padding;
  const LocationDetailsBox({
    super.key,
    this.heading,
    this.padding,
    required this.locationType,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSettingContainer(
      padding: padding,
      heading: heading,
      content: BlocBuilder<LocationRenderCubit, LocationRenderState>(
        builder: (context, locationState) {
          final locationModel = locationType == LocationType.socialMedia
              ? locationState.socialMediaLocation
              : locationState.marketPlaceLocation;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.location_on_sharp,
                  color: ApplicationColours.themeBlueColor,
                  size: 16,
                ),
              ),
              Expanded(
                child: locationModel != null
                    ? Text(
                        locationModel.address,
                        style: const TextStyle(fontSize: 14),
                      )
                    : Text(
                        tr(LocaleKeys.addYourLocation),
                        style: const TextStyle(fontSize: 15),
                      ),
              ),
            ],
          );
        },
      ),
      buttonName: LocaleKeys.updateLocation,
      buttonOnTap: () {
        GoRouter.of(context)
            .pushNamed(LocationManageMapScreen.routeName, extra: {
          'locationType': locationType,
          'locationManageType': LocationManageType.setting,
        });
      },
    );
  }
}
