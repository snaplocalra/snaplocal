import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class OwnerActivityDetailsWidgetByType extends StatelessWidget {
  const OwnerActivityDetailsWidgetByType({
    super.key,
    required this.ownerActivity,
  });

  final OwnerActivityDetailsModel ownerActivity;

  @override
  Widget build(BuildContext context) {
    switch (ownerActivity.runtimeType) {
      case const (BuySellActivityModel):
        final buySellData = ownerActivity as BuySellActivityModel;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${tr(LocaleKeys.bought)}-${buySellData.boughtCount}",
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
              child: VerticalDivider(
                width: 15,
                thickness: 1.5,
                color: Color.fromRGBO(112, 112, 112, 0.4),
              ),
            ),
            Text(
              "${tr(LocaleKeys.sold)}-${buySellData.soldCount}",
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case const (JobActivityModel):
        final jobData = ownerActivity as JobActivityModel;
        return Center(
          child: Text(
            "${tr(LocaleKeys.posted)}-${jobData.jobPosted}",
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      default:
        throw Exception("Unknown type: $ownerActivity");
    }
  }
}
