import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());

  Future<void> downloadFile({
    required String url,
    required String fileName,
  }) async {
    final status = await Permission.storage.request();
    // final androidInfo = await DeviceInfoPlugin().androidInfo;
    // final androidSdkVersion = androidInfo.version.sdkInt;
    try {
      //from sdk 33 storage permission is not required
      bool androidSdk = true;
      if (Platform.isAndroid) {

        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidSdkVersion = androidInfo.version.sdkInt;
        if (androidSdkVersion >= 33) {
          androidSdk = false;
        }
      }
      if ( !androidSdk || status.isGranted) {
        final path = await getExternalStorageDirectory();
        String localPath = '${path!.path}/Download';
        final savedDir = Directory(localPath);
        if (!await savedDir.exists()) {
          await savedDir.create();
        }
        Fluttertoast.showToast(
          msg: 'Downloading started...',
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );

        await FlutterDownloader.enqueue(
          url: url,
          savedDir: localPath,
          showNotification: true,
          fileName: fileName,
          // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // click on notification to open downloaded file (for Android)
          saveInPublicStorage: true,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Permission is denied',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
