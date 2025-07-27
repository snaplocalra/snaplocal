import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/logic/business_timming/business_timming_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_timming_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/widgets/business_time_slot_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class BusinessHoursSlotWidget extends StatelessWidget {
  const BusinessHoursSlotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessHoursCubit, BusinessHoursState>(
      builder: (context, businessHoursState) {
        final businessHoursModel = businessHoursState.businessHoursModel;
        return Column(
          children: [
            BusinessHourOpenOptionWidget(
              alwaysOpen: businessHoursModel.alwaysOpen,
              onAlwaysOpenChanged: (status) {
                context
                    .read<BusinessHoursCubit>()
                    .changeAlwaysOpenStatus(status);
              },
            ),
            if (!businessHoursModel.alwaysOpen)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: businessHoursModel.businessWeekDayModel.length,
                itemBuilder: (context, index) {
                  final businessWeekDay =
                      businessHoursModel.businessWeekDayModel[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: BusinessWeekDayWidget(
                      businessWeekDayModel: businessWeekDay,
                      index: index,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class BusinessWeekDayWidget extends StatelessWidget {
  final BusinessWeekDayModel businessWeekDayModel;
  final int index;

  const BusinessWeekDayWidget({
    super.key,
    required this.businessWeekDayModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    //In a row, there is a checkbox, and in column, there is a text and a time picker
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: !businessWeekDayModel.isClosed,
          onChanged: (status) {
            context
                .read<BusinessHoursCubit>()
                .changeTheCloseStatus(index, !status!);
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessWeekDayModel.weekDay,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              businessWeekDayModel.isClosed
                  ? Text(
                      tr(LocaleKeys.closed),
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black54),
                    )
                  : BusinessTimeSlotCard(
                      index: index,
                      businessWeekDayModel: businessWeekDayModel,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class BusinessTimeSlotCard extends StatelessWidget {
  const BusinessTimeSlotCard({
    super.key,
    required this.index,
    required this.businessWeekDayModel,
  });

  final int index;
  final BusinessWeekDayModel businessWeekDayModel;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          //1st half time
          BusinessTimeSlotWidget(
            onFromTimeSelected: (selectedTime) {
              context
                  .read<BusinessHoursCubit>()
                  .addFirstHalfTime(index, openTime: selectedTime);
            },
            onToTimeSelected: (selectedTime) {
              context
                  .read<BusinessHoursCubit>()
                  .addFirstHalfTime(index, closeTime: selectedTime);
            },
            existFromTime:
                businessWeekDayModel.businessTimmingModel?.firstHalfOpeningTime,
            existToTime:
                businessWeekDayModel.businessTimmingModel?.firstHalfClosingTime,
          ),

          businessWeekDayModel
                      .businessTimmingModel?.isSecondHalfTimeAvailable ??
                  false
              ?
              //2nd half time
              Row(children: [
                  const Text("  &  "),
                  BusinessTimeSlotWidget(
                    onFromTimeSelected: (selectedTime) {
                      context
                          .read<BusinessHoursCubit>()
                          .addSecondHalfTime(index, openTime: selectedTime);
                    },
                    onToTimeSelected: (selectedTime) {
                      context
                          .read<BusinessHoursCubit>()
                          .addSecondHalfTime(index, closeTime: selectedTime);
                    },
                    existFromTime: businessWeekDayModel
                        .businessTimmingModel?.secondHalfOpeningTime,
                    existToTime: businessWeekDayModel
                        .businessTimmingModel?.secondHalfClosingTime,
                  ),
                  //cross to remove the 2nd half time
                  IconButton(
                    onPressed: () {
                      context
                          .read<BusinessHoursCubit>()
                          .removeSecondHalfTime(index);
                    },
                    icon: const Icon(Icons.close),
                    color: ApplicationColours.themeBlueColor,
                  ),
                ])
              : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<BusinessHoursCubit>()
                          .addSecondHalfTime(index);
                    },
                    child: Text(
                      tr(LocaleKeys.addSetOfHours),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: ApplicationColours.themeLightPinkColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class BusinessHourOpenOptionWidget extends StatelessWidget {
  final bool alwaysOpen;
  final void Function(bool) onAlwaysOpenChanged;
  const BusinessHourOpenOptionWidget({
    super.key,
    required this.alwaysOpen,
    required this.onAlwaysOpenChanged,
  });

  @override
  Widget build(BuildContext context) {
    //If always open is true then select the always open radio button
    //else select the Selected Hours radio button

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: false,
                    groupValue: alwaysOpen,
                    onChanged: (status) => onAlwaysOpenChanged.call(status!),
                  ),
                  Transform.translate(
                    // Adjust the offset values as needed
                    offset: const Offset(-8, 0),
                    child: Text(
                      tr(LocaleKeys.selectedHours),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //Always open radio button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: true,
                    groupValue: alwaysOpen,
                    onChanged: (status) => onAlwaysOpenChanged.call(status!),
                  ),
                  Transform.translate(
                    // Adjust the offset values as needed
                    offset: const Offset(-8, 0),
                    child: Text(
                      tr(LocaleKeys.alwaysOpen),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
