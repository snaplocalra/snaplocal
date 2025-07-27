import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_hours_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_timming_model.dart';

part 'business_timming_state.dart';

class BusinessHoursCubit extends Cubit<BusinessHoursState> {
  BusinessHoursCubit()
      : super(
          BusinessHoursState(
            businessHoursModel: BusinessHoursModel(
              alwaysOpen: false,
              businessWeekDayModel: _getInitialBusinessWeekDayModel(),
            ),
          ),
        );

//9am default open time, 6pm default close time
//Take the current date and set the time to 9am and 6pm
  static final currentDateTime = DateTime.now();

  static DateTime defaultOpenTime = DateTime(
    currentDateTime.year,
    currentDateTime.month,
    currentDateTime.day,
    9, //9am
  );
  static DateTime defaultCloseTime = DateTime(
    currentDateTime.year,
    currentDateTime.month,
    currentDateTime.day,
    18, //6pm
  );

  //Initial business week days
  static List<BusinessWeekDayModel> _getInitialBusinessWeekDayModel() {
    final businessTimmingModel = BusinessTimmingModel(
      firstHalfOpeningTime: defaultOpenTime,
      firstHalfClosingTime: defaultCloseTime,
    );
    //Initial business week days
    return [
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.sunday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.monday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.tuesday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.wednesday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.thursday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.friday),
        businessTimmingModel: businessTimmingModel,
      ),
      BusinessWeekDayModel(
        isClosed: false,
        weekDay: tr(LocaleKeys.saturday),
        businessTimmingModel: businessTimmingModel,
      ),
    ];
  }

  //Render the business hours
  //This will be called on edit business details
  void renderBusinessHours(BusinessHoursModel businessHoursModel) {
    //create a copy of the business week day list
    final businessWeekDayModel = List<BusinessWeekDayModel>.from(
      //If the business week day model is empty, then set the initial business week day model
      businessHoursModel.businessWeekDayModel.isEmpty
          ? _getInitialBusinessWeekDayModel()
          : businessHoursModel.businessWeekDayModel.map(
              (businessWeekDay) =>
                  //If some of the business timing model is null,
                  //then set the default open and close time
                  businessWeekDay.businessTimmingModel == null
                      ? businessWeekDay.copyWith(
                          businessTimmingModel: BusinessTimmingModel(
                          firstHalfOpeningTime: defaultOpenTime,
                          firstHalfClosingTime: defaultCloseTime,
                        ))
                      : businessWeekDay,
            ),
    );

    //emit the state
    emit(BusinessHoursState(
        businessHoursModel: businessHoursModel.copyWith(
      businessWeekDayModel: businessWeekDayModel,
    )));
  }

  // changeTheCloseStatus
  void changeTheCloseStatus(int index, bool status) {
    emit(state.copyWith(dataLoading: true));

    //create a instance of the current state
    final businessHoursModel = state.businessHoursModel;

    //Update the business close status
    businessHoursModel.businessWeekDayModel[index] = businessHoursModel
        .businessWeekDayModel[index]
        .copyWith(isClosed: status);

    //Emit new status
    emit(BusinessHoursState(businessHoursModel: businessHoursModel));
  }

  //Add 1st half time
  void addFirstHalfTime(
    int index, {
    DateTime? openTime,
    DateTime? closeTime,
  }) {
    emit(state.copyWith(dataLoading: true));

    //create a instance of the current state
    final businessHoursModel = state.businessHoursModel;

    //Take the instance of the business week day model
    final businessWeekDayModel = businessHoursModel.businessWeekDayModel[index];

    //Update the business 1st half time
    businessHoursModel.businessWeekDayModel[index] =
        businessWeekDayModel.copyWith(
      businessTimmingModel: businessWeekDayModel.businessTimmingModel!.copyWith(
        firstHalfOpeningTime: openTime,
        firstHalfClosingTime: closeTime,
      ),
    );

    //Emit new status
    emit(BusinessHoursState(businessHoursModel: businessHoursModel));
  }

  //Add 2nd half time
  void addSecondHalfTime(
    int index, {
    DateTime? openTime,
    DateTime? closeTime,
  }) {
    emit(state.copyWith(dataLoading: true));

    //If the method called without open and close time, then make it true
    final enableSecondHalfTime = openTime == null && closeTime == null;

    //create a instance of the current state
    final businessHoursModel = state.businessHoursModel;

    //Take the instance of the business week day model
    final businessWeekDayModel = businessHoursModel.businessWeekDayModel[index];

    //Update the business 2nd half time
    businessHoursModel.businessWeekDayModel[index] =
        businessWeekDayModel.copyWith(
      businessTimmingModel: businessWeekDayModel.businessTimmingModel!.copyWith(
        secondHalfOpeningTime:
            enableSecondHalfTime ? defaultOpenTime : openTime,
        secondHalfClosingTime:
            enableSecondHalfTime ? defaultCloseTime : closeTime,
      ),
    );

    //Emit new status
    emit(BusinessHoursState(businessHoursModel: businessHoursModel));
  }

  //remove 2nd half time
  void removeSecondHalfTime(int index) {
    emit(state.copyWith(dataLoading: true));

    //create a instance of the current state
    final businessHoursModel = state.businessHoursModel;

    //Take the instance of the business week day model
    final businessWeekDayModel = businessHoursModel.businessWeekDayModel[index];

    //Update the business 2nd half time
    businessHoursModel.businessWeekDayModel[index] =
        businessWeekDayModel.copyWith(
      businessTimmingModel:
          businessWeekDayModel.businessTimmingModel!.makeSecondHalfTimeNull(),
    );

    //Emit new status
    emit(BusinessHoursState(businessHoursModel: businessHoursModel));
  }

  //Change the always open status
  void changeAlwaysOpenStatus(bool alwaysOpen) {
    //Update the always open status and Emit new status
    emit(BusinessHoursState(
      businessHoursModel: state.businessHoursModel.copyWith(
        alwaysOpen: alwaysOpen,
      ),
    ));
  }
}
