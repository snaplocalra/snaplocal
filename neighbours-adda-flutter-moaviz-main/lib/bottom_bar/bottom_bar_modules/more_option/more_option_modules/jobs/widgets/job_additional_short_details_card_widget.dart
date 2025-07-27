import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class JobAdditionalShortDetailsCardWidget extends StatelessWidget {
  final double minWorkExperience;
  final double maxWorkExperience;
  final LocationAddressWithLatLng workLocation;
  final List<String> skills;
  final double? jobDetailsHorizontalPadding;
  final Color? skillColor;
  const JobAdditionalShortDetailsCardWidget({
    super.key,
    required this.minWorkExperience,
    required this.maxWorkExperience,
    required this.workLocation,
    required this.skills,
    this.jobDetailsHorizontalPadding,
    this.skillColor,
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
              // Work Experience Row
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 2),
                child: Row(
                  children: [
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
                  ],
                ),
              ),

              // Location Row
              AddressWithLocationIconWidget(
                address: workLocation.address,
                iconSize: 16,
                fontSize: 12,
                iconTopPadding: 0,
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ),

        // Job Skills
        Visibility(
          visible: skills.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 3.5,
              ),
              //If skills are more than 3 then show only 3 skills
              itemCount: skills.length > 3 ? 3 : skills.length,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      skillColor ?? const Color.fromRGBO(242, 239, 239, 0.33),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  child: Text(
                    skills[index],
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
