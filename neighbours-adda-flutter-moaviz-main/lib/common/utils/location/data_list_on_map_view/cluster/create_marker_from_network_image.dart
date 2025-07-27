import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> _loadNetworkImage(String imageUrl) async {
  final dio = Dio();

  try {
    final response = await dio.get<Uint8List>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    return response.data!;
  } catch (error) {
    throw Exception('Failed to load image');
  }
}

Future<Uint8List> _resizeImage(Uint8List image) async {
  img.Image imgData = img.decodeImage(image)!;
  img.Image resizedImage = img.copyResize(imgData, width: 100, height: 100);
  return Uint8List.fromList(img.encodePng(resizedImage));
}

Future<Uint8List> _loadImageData(String imageUrl) async {
  Uint8List image = await _loadNetworkImage(imageUrl);
  return await _resizeImage(image);
}

// Future<BitmapDescriptor> createImageIcon(String imageUrl) async {
//   BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
//   final imageData = await _loadImageData(imageUrl);
//   markerIcon = BitmapDescriptor.fromBytes(imageData);
//   return markerIcon;
// }

Future<BitmapDescriptor> createImageIcon(String imageUrl) async {
  int size = 75;

  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint1 = Paint()..color = Colors.orange;
  final Paint paint2 = Paint()..color = Colors.white;

  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

  final Uint8List markerIconData = await _loadImageData(imageUrl);
  final Codec codec = await instantiateImageCodec(markerIconData);
  final FrameInfo frameInfo = await codec.getNextFrame();
  paintImage(
    canvas: canvas,
    rect: Rect.fromLTWH(0.0, 0.0, size.toDouble(), size.toDouble()),
    image: frameInfo.image,
  );

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.bytes(data.buffer.asUint8List());
}
