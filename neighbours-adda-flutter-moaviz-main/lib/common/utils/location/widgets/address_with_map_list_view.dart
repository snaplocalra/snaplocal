import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/widget/data_list_or_map_view_switch.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class AddressWithMapListSwitch extends StatelessWidget {
  const AddressWithMapListSwitch({
    super.key,
    required this.locationType,
    this.enableLocateMe = false,
  });

  final LocationType locationType;
  final bool enableLocateMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AddressWithLocateMe(
            is3D: true,
            iconSize: 15,
            iconTopPadding: 0,
            locationType: locationType,
            enableLocateMe: enableLocateMe,
            contentMargin: EdgeInsets.zero,
            height: 35,
            decoration: BoxDecoration(
              color: ApplicationColours.skyColor.withOpacity(1),
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: null,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 40,
            child: VerticalDivider(
              thickness: 0.5, // Decreased thickness
              width: 1, // Decreased height
              color: Colors.black,
            ),
          ),
        ),
        const DataListOrMapViewSwitch()
      ],
    );
  }
}
