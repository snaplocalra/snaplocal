import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_discount_option_model.dart';
import 'package:snap_local/common/utils/widgets/text_scroll_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

enum BusinessDiscountType { percentage, price }

class BusinessDiscountWidget extends StatelessWidget {
  final BusinessDiscountOptionModel businessDiscountOption;
  final BusinessDiscountType businessDiscountType;
  const BusinessDiscountWidget({
    super.key,
    required this.businessDiscountOption,
    required this.businessDiscountType,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(10),
        strokeWidth: 2,
        color: ApplicationColours.themePinkColor,
        dashPattern: const [4, 4],
      ),
      child: Container(
        width: 150,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              businessDiscountType == BusinessDiscountType.percentage
                  ? "${businessDiscountOption.value}% OFF"
                  : "₹${businessDiscountOption.value} OFF",
              style: TextStyle(
                  color: ApplicationColours.themePinkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: ApplicationColours.themePinkColor,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                child: Center(
                    child: TextScrollWidget(
                  text: "on ${businessDiscountOption.discountOn}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
