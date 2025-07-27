import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseMessageService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String> generateFirebaseMessageToken() async {
    try {
      final deviceToken = await firebaseMessaging.getToken();
      if (deviceToken != null) {
        return deviceToken;
      } else {
        print("Unable to register device");
        throw ("Unable to register device");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<void> deleteFirebaseMessageToken() async {
    try {
      await firebaseMessaging.deleteToken();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
