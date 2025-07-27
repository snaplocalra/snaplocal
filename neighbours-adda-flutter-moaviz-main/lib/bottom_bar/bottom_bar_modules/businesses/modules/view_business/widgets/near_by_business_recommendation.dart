import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/short_business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/business_short_details_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class OtherNearByBusinessRecommendation extends StatelessWidget {
  const OtherNearByBusinessRecommendation({
    super.key,
    required this.nearbyList,
  });

  final List<ShortBusinessDetailsModel> nearbyList;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    double listHeight = 140;
    double widgetWidth = mqSize.width * 0.75;

    return Visibility(
      visible: nearbyList.isNotEmpty,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                tr(LocaleKeys.otherNearbyRecommendations),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: listHeight,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: nearbyList.length,
                itemBuilder: (context, index) {
                  final businessDetails = nearbyList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: BusinessShortDetailsWidget(
                        width: widgetWidth,
                        businessId: businessDetails.id,
                        businessName: businessDetails.businessName,
                        businessAddress: businessDetails.postLocation.address,
                        businessCategory: businessDetails
                            .category.selectedCategories
                            .map((e) => e.name)
                            .join(","),
                        distance: businessDetails.distance,
                        businessMedia: businessDetails.media.first,
                        ratings: businessDetails.ratingsModel.starRating,
                        unbeatableDeal: businessDetails.isUnbeatableDeal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
