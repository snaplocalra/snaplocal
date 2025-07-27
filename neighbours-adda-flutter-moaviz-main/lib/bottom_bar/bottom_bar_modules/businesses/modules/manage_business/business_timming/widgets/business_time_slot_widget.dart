import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_local/utility/tools/pick_time/pick_time.dart';
import 'package:snap_local/utility/tools/pick_time/time_slot_checker.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class BusinessTimeSlotWidget extends StatefulWidget {
  final void Function(DateTime fromTime) onFromTimeSelected;
  final void Function(DateTime toTime) onToTimeSelected;
  final DateTime? existFromTime;
  final DateTime? existToTime;

  const BusinessTimeSlotWidget({
    super.key,
    this.existFromTime,
    this.existToTime,
    required this.onFromTimeSelected,
    required this.onToTimeSelected,
  });

  @override
  State<BusinessTimeSlotWidget> createState() => _BusinessTimeSlotWidgetState();
}

class _BusinessTimeSlotWidgetState extends State<BusinessTimeSlotWidget> {
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();

  DateTime? fromTime;
  DateTime? toTime;

  void setFromTime(DateTime dateTime) {
    widget.onFromTimeSelected.call(dateTime);
    fromTime = dateTime;
    fromTimeController.text =
        FormatDate.convertDateTimeToAMPM(dateTime: dateTime).toUpperCase();
  }

  void setToTime(DateTime dateTime) {
    widget.onToTimeSelected.call(dateTime);
    toTime = dateTime;
    toTimeController.text =
        FormatDate.convertDateTimeToAMPM(dateTime: dateTime).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existFromTime != null) {
      setFromTime(widget.existFromTime!);
    }

    if (widget.existToTime != null) {
      setToTime(widget.existToTime!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    fromTimeController.dispose();
    toTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 70,
          child: ThemeTextFormField(
            readOnly: true,
            hint: 'From time',
            style: const TextStyle(fontSize: 12),
            hintStyle: const TextStyle(fontSize: 12),
            controller: fromTimeController,
            fillColor: const Color.fromRGBO(246, 246, 246, 1),
            onTap: () async {
              final pickedTime = await Pick().time(
                context,
                initialTime:
                    fromTime != null ? TimeOfDay.fromDateTime(fromTime!) : null,
              );

              if (pickedTime != null) {
                bool isValidTime = true;

                final pickedTimeinDateTime =
                    FormatDate.timeOfTheDayToDateTime(pickedTime);

                //Check whether the "From Time" is lesser than the "To Time" or not
                isValidTime = TimeSlotChecker.isValidTime(
                  fromTime: pickedTime,
                  toTime:
                      toTime != null ? TimeOfDay.fromDateTime(toTime!) : null,
                );

                if (isValidTime || toTime == null) {
                  setFromTime(pickedTimeinDateTime);
                } else {
                  Fluttertoast.showToast(
                    msg: "Invalid time slot",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          width: 70,
          child: ThemeTextFormField(
            readOnly: true,
            controller: toTimeController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            hint: tr(LocaleKeys.toTime),
            style: const TextStyle(fontSize: 12),
            hintStyle: const TextStyle(fontSize: 12),
            fillColor: const Color.fromRGBO(246, 246, 246, 1),
            onTap: () async {
              final pickedTime = await Pick().time(
                context,
                initialTime:
                    toTime != null ? TimeOfDay.fromDateTime(toTime!) : null,
              );

              if (pickedTime != null) {
                bool isValidTime = true;

                final pickedTimeinDateTime =
                    FormatDate.timeOfTheDayToDateTime(pickedTime);

                //Check whether the "From Time" is lesser than the "To Time" or not
                isValidTime = TimeSlotChecker.isValidTime(
                  fromTime: fromTime != null
                      ? TimeOfDay.fromDateTime(fromTime!)
                      : null,
                  toTime: pickedTime,
                );

                if (isValidTime) {
                  setToTime(pickedTimeinDateTime);
                } else {
                  Fluttertoast.showToast(
                    msg: "Invalid time slot",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
