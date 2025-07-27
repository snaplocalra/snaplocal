import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RadiusSlider extends StatelessWidget {
  final double maxRadius;
  final double userSelectedRadius;
  final void Function(double) onRadiusChanged;
  const RadiusSlider({
    super.key,
    required this.maxRadius,
    required this.userSelectedRadius,
    required this.onRadiusChanged,
  });

  final sliderPurpleColour = const Color.fromRGBO(165, 62, 162, 1);
  @override
  Widget build(BuildContext context) {
    const double minRadius = 0.1;
    return SfSliderTheme(
      data: SfSliderThemeData(
        tooltipBackgroundColor: sliderPurpleColour,
        activeTrackColor: sliderPurpleColour,
        inactiveTrackColor: const Color.fromRGBO(173, 175, 187, 0.41),
        thumbColor: sliderPurpleColour,
        thumbRadius: 15,
        // Adjust the tickOffset to add space between slider and ticks
        tickOffset: const Offset(0, 5),
        tooltipTextStyle: const TextStyle(fontSize: 10),
      ),
      child: SfSlider(
        showLabels: true,
        showTicks: true,
        enableTooltip: true,
        tooltipShape: const SfPaddleTooltipShape(),
        thumbIcon: Center(
          child: Text(
            userSelectedRadius.toStringAsFixed(1),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ),
        min: minRadius,
        numberFormat: NumberFormat("#,##0.0 'km'"),
        max: maxRadius,
        value: userSelectedRadius,
        onChanged: (value) =>
            value > minRadius ? onRadiusChanged.call(value) : null,
      ),
    );
  }
}
