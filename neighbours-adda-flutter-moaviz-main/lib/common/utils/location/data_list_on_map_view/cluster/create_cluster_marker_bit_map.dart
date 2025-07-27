import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

Future<BitmapDescriptor> createCircleClusterMarkerBitmap(
  int size, {
  String? text,
}) async {
  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint1 = Paint()..color = ApplicationColours.themeBlueColor;
  final Paint paint2 = Paint()..color = Colors.white;

  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

  if (text != null) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );
  }

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.bytes(data.buffer.asUint8List());
}

Future<BitmapDescriptor> createMaskCircleMarkerBitmap() async {
  int size = 75;
  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint1 = Paint()
    ..color = ApplicationColours.themeBlueColor.withOpacity(0.4);

  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.bytes(data.buffer.asUint8List());
}

Future<ui.Image> _loadPngImage(String path) async {
  // Load PNG image
  final ByteData pngByteData = await rootBundle.load(path);
  final Uint8List pngBytes = pngByteData.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image pngImage = frameInfo.image;

  return pngImage;
}

Future<BitmapDescriptor> createMapPinMarkerBitmap(
    {int? count, required String imagePath}) async {
  int size = 125;

  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Paint paint1 = Paint()..color = ApplicationColours.themeBlueColor;

  // Draw PNG image on canvas
  canvas.drawImage(
    await _loadPngImage(imagePath),
    Offset.zero,
    paint1,
  );

  // Draw text, at the top left of the PNG image with some left offset
  if (count != null) {
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: count.toString(),
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white, // Text color
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    // Calculate the position to center the text horizontally and place it at the top with some space
    // Center text horizontally
    double textX = (size - painter.width) / (count < 10 ? 3 : 4);
    // Set text to the top with 10% of the size as space
    double textY = size * 0.2;

    painter.paint(canvas, Offset(textX, textY));
  } else {
    // Draw a circle with light white color
    final Paint paint2 = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(Offset(size / 3.15, size / 3), 20, paint2);
  }

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.bytes(
    data.buffer.asUint8List(),
    height: 40,
    width: 40,
  );
}

Future<BitmapDescriptor> createMapPinBadgeMarkerBitmap(
    {int? count, required String imagePath}) async {
  int size = 125;
  int dataSize = 115;

  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Paint paint1 = Paint()..color = ApplicationColours.themeBlueColor;

  // Draw PNG image on canvas
  canvas.drawImage(
    await _loadPngImage(imagePath),
    Offset.zero,
    paint1,
  );

  final bool moreThan99 = count != null && count > 99;
  final singleDigit = count != null && count < 10;

  // Draw text, at the top left of the PNG image with some left offset
  if (count != null) {
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: moreThan99 ? '99+' : count.toString(),
        style: TextStyle(
          fontSize: dataSize / 4.5,
          color: Colors.white, // Text color
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    // Calculate the position to center the text horizontally and place it at the top with some space
    // Center text horizontally
    double textX = (dataSize - painter.width) /
        (singleDigit
            ? 1.24
            : moreThan99
                ? 0.95
                : 1.16);
    // Set text to the top with 10% of the size as space
    double textY = dataSize * 0.15;

    // Draw a red circle behind the text with a smaller radius
    final Paint paint3 = Paint()..color = ApplicationColours.themePinkColor;
    canvas.drawCircle(
      Offset(dataSize / (moreThan99 ? 1.2 : 1.3), dataSize / 3.5),
      dataSize / (moreThan99 ? 4.2 : 5.5),
      paint3,
    );

    painter.paint(canvas, Offset(textX, textY));
  }

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.bytes(
    data.buffer.asUint8List(),
    height: 50,
    width: 50,
  );
}
