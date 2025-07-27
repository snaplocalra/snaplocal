import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/date_range_filter_strategy.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/pick_time/pick_time.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class DateRangeFilterWidget extends StatefulWidget {
  final DateTime? selectedFromDate;
  final DateTime? selectedToDate;
  final int filterIndex;
  const DateRangeFilterWidget({
    super.key,
    this.selectedFromDate,
    this.selectedToDate,
    required this.filterIndex,
  });

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  DateTime? fromDate;
  DateTime? toDate;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  late Locale locale = Locale(
    EasyLocalization.of(context)!.locale.languageCode,
    "IN",
  );

  @override
  void initState() {
    super.initState();

    fromDate = widget.selectedFromDate;
    toDate = widget.selectedToDate;

    if (fromDate != null && toDate != null) {
      fromDateController.text = FormatDate.selectedDateDDMMYYYY(fromDate!);
      toDateController.text = FormatDate.selectedDateDDMMYYYY(toDate!);
    }
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr(LocaleKeys.selectDateRange),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ApplicationColours.themeBlueColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //START DATE
                Expanded(
                  child: ThemeTextFormField(
                    readOnly: true,
                    controller: fromDateController,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 14),
                    hint: tr(LocaleKeys.from),
                    hintStyle: const TextStyle(fontSize: 14),
                    onTap: () async {
                      Pick()
                          .date(
                        context,
                        locale: locale,
                        initialDate: fromDate,
                        firstDate: DateTime(2023),
                        lastDate: toDate,
                      )
                          .then((selectedDate) {
                        if (selectedDate != null) {
                          fromDate = selectedDate;
                          fromDateController.text =
                              FormatDate.selectedDateDDMMYYYY(selectedDate);
                        }
                      });
                    },
                    suffixIcon: const Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ///////
                const SizedBox(width: 10),
                //TO DATE
                Expanded(
                  child: ThemeTextFormField(
                    readOnly: true,
                    controller: toDateController,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 14),
                    hint: tr(LocaleKeys.to),
                    hintStyle: const TextStyle(fontSize: 14),
                    onTap: () async {
                      Pick()
                          .date(
                        context,
                        locale: locale,
                        firstDate: fromDate,
                        initialDate: toDate,
                      )
                          .then((selectedDate) {
                        if (selectedDate != null) {
                          toDate = selectedDate;
                          toDateController.text =
                              FormatDate.selectedDateDDMMYYYY(selectedDate);
                        }
                      });
                    },
                    suffixIcon: const Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Apply button
          ThemeElevatedButton(
            onPressed: () {
              //update the filter value
              context.read<DataFilterCubit>().updateFilter(
                    filterIndex: widget.filterIndex,
                    strategy: DateRangeFilterStrategy(
                      fromDate: fromDate,
                      toDate: toDate,
                    ),
                  );
              //Apply the filter
              context.read<DataFilterCubit>().applyFilter();
              Navigator.pop(context);
            },
            buttonName: tr(LocaleKeys.apply),
          ),
        ],
      ),
    );
  }
}
