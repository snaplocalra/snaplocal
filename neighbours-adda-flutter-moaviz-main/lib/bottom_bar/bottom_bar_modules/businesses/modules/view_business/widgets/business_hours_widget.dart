import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_hours_model.dart';
import 'package:snap_local/common/utils/widgets/svg_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class BusinessHoursDisplayWidget extends StatelessWidget {
  final BusinessHoursModel businessHoursModel;
  const BusinessHoursDisplayWidget({
    super.key,
    required this.businessHoursModel,
  });

  @override
  Widget build(BuildContext context) {
    //Closed weekdays
    final closedWeekDays = businessHoursModel.businessWeekDayModel
        .where((element) => element.isClosed)
        .toList();

    //Open weekdays
    final openWeekDays = businessHoursModel.businessWeekDayModel
        .where((element) => !element.isClosed)
        .where((element) => element.businessTimmingModel != null)
        .toList();

    return
        //Business Timings
        businessHoursModel.alwaysOpen
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SvgTextWidget(
                  svgImage: SVGAssetsImages.clock,
                  prefixText: tr(LocaleKeys.alwaysOpen),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SvgTextWidget(
                    svgImage: SVGAssetsImages.clock,
                    prefixText: "Timings",
                  ),
                  //Opening time
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: openWeekDays.length,
                    itemBuilder: (context, index) {
                      final businessHours = openWeekDays[index];
                      final timing = businessHours.businessTimmingModel;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 2, 0, 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${businessHours.weekDay} : ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${FormatDate.ampm(timing!.firstHalfOpeningTime)} - ${FormatDate.ampm(timing.firstHalfClosingTime)}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            if (timing.isSecondHalfTimeAvailable)
                              Text(
                                " | ${FormatDate.ampm(timing.secondHalfOpeningTime!)} - ${FormatDate.ampm(timing.secondHalfClosingTime!)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  //Closed weekdays
                  Visibility(
                    visible: closedWeekDays.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: closedWeekDays.length,
                              itemBuilder: (context, index) {
                                final businessHours = closedWeekDays[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    businessHours.weekDay,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SvgPicture.asset(
                            SVGAssetsImages.closed,
                            height: 60,
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              );
  }
}
