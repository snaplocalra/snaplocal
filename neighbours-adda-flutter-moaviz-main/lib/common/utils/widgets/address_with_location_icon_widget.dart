import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/text_scroll_widget.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class AddressWithLocationIconWidget extends StatelessWidget {
  const AddressWithLocationIconWidget({
    super.key,
    required this.address,
    this.iconSize = 14,
    this.fontSize = 13,
    this.iconTopPadding = 3,
    this.icon = Icons.location_on_sharp,
    this.iconColour,
    this.textColour,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.latitude,
    this.longitude,
    this.hideIcon = false,
    this.enableOpeningMap = true,
  });

  final bool hideIcon;
  final String address;
  final double iconSize;
  final double fontSize;
  final double iconTopPadding;
  final IconData icon;
  final Color? iconColour;
  final Color? textColour;
  final CrossAxisAlignment crossAxisAlignment;
  final double? latitude;
  final double? longitude;
  final bool enableOpeningMap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (latitude != null && longitude != null) {
          if (enableOpeningMap) {
            UrlLauncher().openMap(
              latitude: latitude!,
              longitude: longitude!,
            );
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (!hideIcon)
            Padding(
              padding: EdgeInsets.only(top: iconTopPadding),
              child: Icon(
                icon,
                color: iconColour ?? ApplicationColours.themeBlueColor,
                size: iconSize,
              ),
            ),
          Expanded(
            child: ExpandedTextScrollWidget(
              text: address,
              style: TextStyle(
                fontSize: fontSize,
                color: textColour,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
