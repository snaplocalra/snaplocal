import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> _addCustomIcon(
  String assetImageMapMarker,
  double markerSize,
) async {
  final ByteData byteData = await rootBundle.load(assetImageMapMarker);
  final Uint8List imageData = byteData.buffer.asUint8List();

  final ui.Codec codec = await ui.instantiateImageCodec(imageData);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image image = frameInfo.image;

  final double targetWidth = markerSize;
  final double targetHeight = markerSize;

  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  canvas.drawImage(image, Offset.zero, Paint());

  final ui.Picture picture = pictureRecorder.endRecording();
  final ui.Image resizedImage = await picture.toImage(
    targetWidth.toInt(),
    targetHeight.toInt(),
  );

  final ByteData? resizedByteData =
      await resizedImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List resizedImageData = resizedByteData!.buffer.asUint8List();

  return BitmapDescriptor.bytes(
    resizedImageData,
    height: 40,
    width: 40,
  );
}

Future<Set<Marker>> createMarker({
  required LatLng selectedLocation,
  required String assetImageMapMarker,
}) async {
  final markerIcon = await _addCustomIcon(assetImageMapMarker, 120);

  Set<Marker> markers = <Marker>{};

  markers.clear();
  markers.add(
    Marker(
      markerId: const MarkerId("location"),
      position: selectedLocation,
      icon: markerIcon,
    ),
  );

  return markers;
}
