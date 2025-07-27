 // SfRangeSliderTheme(
                //   data: SfRangeSliderThemeData(
                //     tooltipBackgroundColor: sliderPurpleColour,
                //     activeTrackColor: sliderPurpleColour,
                //     thumbColor: sliderPurpleColour,
                //     thumbRadius: 10,
                //     // Adjust the tickOffset to add space between slider and ticks
                //     tickOffset: const Offset(0, 5),
                //     tooltipTextStyle: const TextStyle(fontSize: 10),
                //   ),
                //   child: SizedBox(
                //     height: 100,
                //     child: SfRangeSlider(
                //       numberFormat: NumberFormat("#,##0.0 'km'"),
                //       min: 0.1,
                //       max: distanceFilter.allowedMaxDistance,
                //       values: values,
                //       showLabels: true,
                //       showTicks: true,
                //       enableTooltip: true,
                //       tooltipShape: const SfPaddleTooltipShape(),
                //       onChanged: (value) {
                //         values = value;
                //         sliderState(() {
                //           if (timer != null && timer!.isActive) {
                //             timer!.cancel();
                //           }
                //           timer = Timer(const Duration(milliseconds: 1000), () {
                //             context
                //                 .read<DataFilterCubit>()
                //                 .updateDistanceRangeFilter(
                //                   filterIndex: filterIndex,
                //                   distanceRange: value,
                //                 );

                //             //Apply the filter
                //             context.read<DataFilterCubit>().applyFilter();

                //             if (Navigator.canPop(context)) {
                //               Navigator.pop(context);
                //             }
                //           });
                //         });
                //       },
                //     ),
                //   ),
                // ),