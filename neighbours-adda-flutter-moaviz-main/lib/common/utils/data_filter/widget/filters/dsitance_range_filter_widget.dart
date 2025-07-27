import 'dart:async';

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/distance_range_filter_strategy.dart';
import 'package:snap_local/common/utils/location/widgets/radius_slider.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class DistanceRangeFilterWidget extends StatefulWidget {
  final DistanceRangeFilter filter;
  final int filterIndex;
  const DistanceRangeFilterWidget({
    super.key,
    required this.filter,
    required this.filterIndex,
  });

  @override
  State<DistanceRangeFilterWidget> createState() =>
      _DistanceRangeFilterWidgetState();
}

class _DistanceRangeFilterWidgetState extends State<DistanceRangeFilterWidget> {
  Timer? timer;
  late double userSelectedRadius = widget.filter.selectedMaxDistance;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, sliderState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr(LocaleKeys.selectDistance),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ApplicationColours.themeBlueColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RadiusSlider(
                maxRadius: widget.filter.allowedMaxDistance,
                userSelectedRadius: userSelectedRadius,
                onRadiusChanged: (value) {
                  userSelectedRadius = value;
                  sliderState(() {
                    if (timer != null && timer!.isActive) {
                      timer!.cancel();
                    }
                    timer = Timer(const Duration(milliseconds: 1000), () {
                      context.read<DataFilterCubit>().updateFilter(
                            filterIndex: widget.filterIndex,
                            strategy: DistanceRangeFilterStrategy(
                              selectedMaxDistance: value,
                            ),
                          );

                      //Apply the filter
                      context.read<DataFilterCubit>().applyFilter();

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  });
                },
              ),
            ),

            //Apply button
            ThemeElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              buttonName: tr(LocaleKeys.close),
            ),
          ],
        ),
      );
    });
  }
}
