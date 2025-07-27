import 'dart:io';

import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snap_local/utility/application_version_checker/repository/version_check_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

part 'application_version_checker_state.dart';

class ApplicationVersionCheckerCubit
    extends Cubit<ApplicationVersionCheckerState> {
  final VersionCheckRepository versionCheckRepositoy;

  ApplicationVersionCheckerCubit({
    required this.versionCheckRepositoy,
  }) : super(ApplicationVersionCheckingLoading());

  Future<void> checkApplicationVersion() async {
    try {
      //Fetch the current application version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);

      //Emit the loading state
      emit(ApplicationVersionCheckingLoading());

      //Fetch the latest version details
      final serverVersionDetails =
          await versionCheckRepositoy.checkVersionData();

      final serverVersion = Version.parse(serverVersionDetails.latestVersion);

      //Check for the version
      if (serverVersion.compareTo(currentVersion) == 1) {
        if (serverVersionDetails.isCriticalUpdateRequired) {
          //Emit the critical update found state
          emit(CriticalUpdateFound(
            applicationDownloadLink: serverVersionDetails.downloadLink,
          ));
        } else {
          //Emit the normal update found state
          emit(NormalUpdateFound(
            applicationDownloadLink: serverVersionDetails.downloadLink,
          ));
        }
      } else {
        emit(NoUpdateFound());
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(ApplicationVersionCheckError(error: e.toString()));
    }
  }

  Future<void> updateApplciation({
    required String applciationDownloadLink,
  }) async {
    HapticFeedback.lightImpact();
    final url = Uri.parse(applciationDownloadLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Fluttertoast.showToast(
        msg:
            "Unable to open ${Platform.isAndroid ? "Play Store" : "App Store"}",
      );
    }
  }
}
