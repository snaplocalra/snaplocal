import 'dart:math' as math;

double calculateZoomLevel(double circleRadius) {
  double zoomValue = 15;

  if (circleRadius <= 1000) {
    zoomValue = 15;
  } else {
    double logRadius = math.log(circleRadius);
    zoomValue = 16 - (logRadius - 6) * 1.1;
  }

  if (zoomValue >= 12 && zoomValue < 14) {
    zoomValue -= 1;
  } else if (zoomValue >= 11 && zoomValue < 12) {
    zoomValue -= 1.5;
  } else if (zoomValue < 11) {
    zoomValue -= 2;
  }

  // Ensure the zoom level doesn't go below a certain threshold
  zoomValue = math.max(zoomValue, 2);

  return zoomValue;
}
