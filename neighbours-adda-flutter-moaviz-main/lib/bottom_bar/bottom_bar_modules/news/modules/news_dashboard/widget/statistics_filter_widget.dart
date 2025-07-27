import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_statistics_filter_controller/news_dashboard_statistics_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/time_frame_enum.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class StatisticsFilterWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const StatisticsFilterWidget({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ApplicationColours.themeBlueColor,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class TimeFrameFilter extends StatelessWidget {
  final TimeFrameEnum? timeFrameEnum;
  const TimeFrameFilter({
    super.key,
    required this.timeFrameEnum,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticsFilterWidget(
      title: tr(LocaleKeys.timeFrame),
      //dropdown
      child: ThemeTextFormFieldDropDown<TimeFrameEnum>(
        value: timeFrameEnum,
        hint: tr(LocaleKeys.selectTimeFrame),
        hintStyle: const TextStyle(fontSize: 12),
        style: const TextStyle(color: Colors.black, fontSize: 10),
        onChanged: (TimeFrameEnum? newValue) {
          if (newValue != null) {
            //Fetch the news dashboard statistics based on the selected timeframe
            context
                .read<NewsDashboardStatisticsFilterControllerCubit>()
                .setTimeFrame(newValue);
          }
        },
        items: <TimeFrameEnum>[
          TimeFrameEnum.twentyFourHours,
          TimeFrameEnum.oneWeek,
          TimeFrameEnum.oneMonth,
          TimeFrameEnum.sixMonths,
          TimeFrameEnum.oneYear,
        ].map<DropdownMenuItem<TimeFrameEnum>>((TimeFrameEnum value) {
          return DropdownMenuItem<TimeFrameEnum>(
            value: value,
            child: Text(
              value.displayValue,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DateRangeFilterWidget extends StatefulWidget {
  final DateTimeRange? dateRange;
  const DateRangeFilterWidget({
    super.key,
    required this.dateRange,
  });

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  final dateRangeController = TextEditingController();

  @override
  void didUpdateWidget(covariant DateRangeFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      if (widget.dateRange == null) {
        dateRangeController.clear();
      }
    }
  }

  @override
  dispose() {
    dateRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsFilterWidget(
      title: tr(LocaleKeys.dateRange),
      child: ThemeTextFormField(
        controller: dateRangeController,
        readOnly: true,
        hint: tr(LocaleKeys.selectDates),
        hintStyle: const TextStyle(fontSize: 12),
        style: const TextStyle(fontSize: 12),
        prefixIcon: const Icon(Icons.calendar_month_outlined),
        onTap: () async {
          final newsDashboardStatisticsFilterControllerCubit =
              context.read<NewsDashboardStatisticsFilterControllerCubit>();

          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2024),
            lastDate: DateTime.now(),
          );

          if (picked != null) {
            newsDashboardStatisticsFilterControllerCubit.setDateRange(picked);

            dateRangeController.text =
                "${FormatDate.selectedDateSlashDDMMYYYY(picked.start)} to ${FormatDate.selectedDateSlashDDMMYYYY(picked.end)}";
          }
        },
      ),
    );
  }
}
