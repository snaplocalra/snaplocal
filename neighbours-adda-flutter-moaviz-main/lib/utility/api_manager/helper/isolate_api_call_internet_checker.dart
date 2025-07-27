import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_handler/logic/internet/internet_cubit.dart';
import 'package:snap_local/utility/constant/errors.dart';

///Run the method if internet available
Future<R> makeIsolateApiCallWithInternetCheck<M, R>(
  FutureOr<R> Function(M) callback,
  M message,
) async {
  try {
    final isInternetAvailable = await InternetCubit().isInternetAvailable();

    if (isInternetAvailable) {
      return await compute(callback, message);
    } else {
      throw (ErrorConstants.noInternet);
    }
  } catch (e) {
    // Record the error in Firebase Crashlytics
    FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    rethrow;
  }
}
