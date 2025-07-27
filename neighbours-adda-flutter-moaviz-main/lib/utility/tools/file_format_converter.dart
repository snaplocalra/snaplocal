  import 'dart:io';

import 'package:flutter/foundation.dart';

Future<File> uint8ListToFile(Uint8List uint8List, String filePath) async {
    if (filePath.isEmpty) {
      throw ArgumentError("File path cannot be null or empty");
    }
    final file = File(filePath);
    await file.writeAsBytes(uint8List);
    return file;
  }

  Future<Uint8List> fileToUint8List(File file) async {
    // Read the file as bytes
    List<int> rawImageBytes = await file.readAsBytes();

    // Convert the List<int> to Uint8List
    Uint8List rawImageUint8List = Uint8List.fromList(rawImageBytes);
    return rawImageUint8List;
  }
