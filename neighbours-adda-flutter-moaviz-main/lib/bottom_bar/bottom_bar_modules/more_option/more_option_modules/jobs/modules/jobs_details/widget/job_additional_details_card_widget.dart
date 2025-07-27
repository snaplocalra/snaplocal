import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/svg_elevated_button.dart';
import 'package:snap_local/common/utils/widgets/svg_text_widget.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class JobAdditionalDetailsCardWidget extends StatelessWidget {
  final double minWorkExperience;
  final double maxWorkExperience;
  final double minSalary;
  final double maxSalary;
  final String distance;
  final LocationAddressWithLatLng workLocation;
  final List<String> skills;
  final double? jobDetailsHorizontalPadding;
  final DateTime createdAt;

  /// This widget will be displayed at the end of the job details
  final Widget? suffixWidget;

  const JobAdditionalDetailsCardWidget({
    super.key,
    required this.minWorkExperience,
    required this.maxWorkExperience,
    required this.minSalary,
    required this.maxSalary,
    required this.workLocation,
    required this.skills,
    required this.distance,
    required this.createdAt,
    this.jobDetailsHorizontalPadding,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job details
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: jobDetailsHorizontalPadding ?? 10,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(LocaleKeys.jobDetails),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (suffixWidget != null) suffixWidget!,
                ],
              ),
              const SizedBox(height: 5),
              // Work Experience Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    //Job experience
                    SvgPicture.asset(
                      SVGAssetsImages.bag,
                      fit: BoxFit.fitWidth,
                      height: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${minWorkExperience.formatNumber()}-${maxWorkExperience.formatNumber()} Yrs",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        width: 15,
                        thickness: 1.5,
                        color: Color.fromRGBO(112, 112, 112, 0.4),
                      ),
                    ),

                    //Salary
                    SvgPicture.asset(
                      SVGAssetsImages.salary,
                      fit: BoxFit.fitWidth,
                      height: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "₹${minSalary.formatPrice()} to ₹${maxSalary.formatPrice()}",
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        width: 15,
                        thickness: 1.5,
                        color: Color.fromRGBO(112, 112, 112, 0.4),
                      ),
                    ),

                    //posted at
                    SvgTextWidget(
                      svgImage: SVGAssetsImages.calendar,
                      svgheight: 12,
                      prefixText:
                          "Posted on ${FormatDate.selectedDateSlashDDMMYYYY(createdAt)}",
                      prefixStyle: const TextStyle(
                        fontSize: 11,
                        color: Color.fromRGBO(112, 112, 112, 1),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // Location Row
              Row(
                children: [
                  Expanded(
                    child: AddressWithLocationIconWidget(
                      address: workLocation.address,
                      iconSize: 16,
                      fontSize: 12,
                      iconTopPadding: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      width: 15,
                      thickness: 1.5,
                      color: Color.fromRGBO(112, 112, 112, 0.4),
                    ),
                  ),
                  RouteWithDistance(
                    distance: distance,
                    iconSize: 14,
                    fontSize: 12,
                  ),
                  const SizedBox(width: 5),
                  // Navigation Button
                  SvgElevatedButton(
                    onTap: () {
                      //Launch Google map
                      UrlLauncher().openMap(
                        latitude: workLocation.latitude,
                        longitude: workLocation.longitude,
                      );
                    },
                    svgImage: SVGAssetsImages.navigation,
                    name: LocaleKeys.navigate,
                    boxHeight: 20,
                    textSize: 10,
                    backgroundcolor: ApplicationColours.themeBlueColor,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Job Skills
        Visibility(
          visible: skills.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 4,
                childAspectRatio: 3.5,
              ),
              itemCount: skills.length,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Text(
                  skills[index],
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
