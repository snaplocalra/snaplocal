//isBusinessOpenNow is true if the business is always open or if the current day is in the open weekdays
//and the current time is in come between the opening and closing time of first or second half
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_hours_model.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

bool checkShopOpenStatus(BusinessHoursModel businessHoursModel) {
  //if the business is always open then return true else check the business hours
  return businessHoursModel.alwaysOpen
      ? true
      : businessHoursModel.businessWeekDayModel
          .where((element) => !element.isClosed)
          .where((element) => element.businessTimmingModel != null)
          .any((element) {
          final businessHours = element.businessTimmingModel;

          final currentDataTime = DateTime.now();
          final currentWeekDay = FormatDate.fullWeekDay(currentDataTime);

          //first half opening time
          final firestHalfOpenTime =
              TimeOfDay.fromDateTime(businessHours!.firstHalfOpeningTime);

          //first half closing time
          final firstHalfCloseTime =
              TimeOfDay.fromDateTime(businessHours.firstHalfClosingTime);

          //second half opening time
          final secondHalfOpenTime = businessHours.isSecondHalfTimeAvailable
              ? TimeOfDay.fromDateTime(businessHours.secondHalfOpeningTime!)
              : null;

          //second half closing time
          final secondHalfCloseTime = businessHours.isSecondHalfTimeAvailable
              ? TimeOfDay.fromDateTime(businessHours.secondHalfClosingTime!)
              : null;

          return element.weekDay == currentWeekDay &&

              //Check with First half time
              ((FormatDate.timeOfTheDayToDateTime(firestHalfOpenTime,
                              specifiedDateTime: currentDataTime)
                          .isBefore(currentDataTime) &&
                      FormatDate.timeOfTheDayToDateTime(firstHalfCloseTime,
                              specifiedDateTime: currentDataTime)
                          .isAfter(currentDataTime)) ||
                  //Check with Second half time
                  (businessHours.isSecondHalfTimeAvailable &&
                      FormatDate.timeOfTheDayToDateTime(secondHalfOpenTime!,
                              specifiedDateTime: currentDataTime)
                          .isBefore(currentDataTime) &&
                      FormatDate.timeOfTheDayToDateTime(secondHalfCloseTime!,
                              specifiedDateTime: currentDataTime)
                          .isAfter(currentDataTime)));
        });
}
