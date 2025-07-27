import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/analytics/logic/analytics_filter/analytics_filter_cubit.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_timeframe_type.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class AnalyticsFilterWidget extends StatefulWidget {
  final void Function() onRefresh;
  const AnalyticsFilterWidget({super.key, required this.onRefresh});

  @override
  State<AnalyticsFilterWidget> createState() => _AnalyticsFilterWidgetState();
}

class _AnalyticsFilterWidgetState extends State<AnalyticsFilterWidget> {
  final dateRangeTextController = TextEditingController();

  @override
  void dispose() {
    dateRangeTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (context.read<AnalyticsFilterCubit>().state.dateTimeRange != null) {
      dateRangeTextController.text = FormatDate.formatDateRange(
        context.read<AnalyticsFilterCubit>().state.dateTimeRange!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnalyticsFilterCubit, AnalyticsFilterState>(
      listener: (context, analyticsFilterState) {
        widget.onRefresh.call();

        if (analyticsFilterState.dateTimeRange != null) {
          // Update the date range text field
          dateRangeTextController.text =
              FormatDate.formatDateRange(analyticsFilterState.dateTimeRange!);
        } else {
          dateRangeTextController.clear();
        }
      },
      builder: (context, analyticsFilterState) {
        return Row(
          children: [
            //Timeframe
            Expanded(
              child: TextFieldWithHeading(
                textFieldHeading: "Timeframe",
                child: ThemeTextFormFieldDropDown<AnalyticsTimeframeType>(
                  hint: "Select Timeframe",
                  hintStyle: const TextStyle(fontSize: 13),
                  value: analyticsFilterState.timeframe,
                  items: AnalyticsTimeframeType.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.displayValue,
                            style: TextStyle(
                              color: ApplicationColours.themeBlueColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<AnalyticsFilterCubit>().setTimeframe(value);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(width: 10),

            //Date Range Text field
            Expanded(
              child: TextFieldWithHeading(
                textFieldHeading: "Date Range",
                child: ThemeTextFormField(
                  controller: dateRangeTextController,
                  hint: "Tap to Select Dates",
                  hintStyle: const TextStyle(fontSize: 12),
                  style: TextStyle(
                    color: ApplicationColours.themeBlueColor,
                    fontSize: 12,
                  ),
                  readOnly: true,
                  onTap: () async {
                    await showDateRangePicker(
                      context: context,
                      initialDateRange: analyticsFilterState.dateTimeRange,
                      firstDate: DateTime(2024),
                      // Last date is 5 years from current date
                      lastDate: DateTime.now(),
                    ).then((dateRange) {
                      if (dateRange != null && context.mounted) {
                        context
                            .read<AnalyticsFilterCubit>()
                            .setDateTimeRange(dateRange);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
