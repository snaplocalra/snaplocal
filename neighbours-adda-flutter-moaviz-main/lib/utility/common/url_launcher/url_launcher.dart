import 'dart:io';

import 'package:designer/utility/theme_toast.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  Future<void> makeCall(String phoneNumber) async {
    try {
      final url = Uri(scheme: 'tel', path: phoneNumber);
      await canLaunchUrl(url).then((bool result) {
        if (result) {
          launchUrl(url);
        } else {
          throw ("Calling not supported");
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  void openMap({required double latitude, required double longitude}) {
    try {
      final locationUrl = Platform.isIOS
          ? "http://maps.apple.com/?ll=$latitude,$longitude"
          : "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

      final url = Uri.parse(locationUrl);
      canLaunchUrl(url).then((bool result) {
        if (result) {
          launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw ("Unable to open map");
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  //Open the email app with the email address and subject
  void sendEmail({required String email, required String subject}) {
    try {
      final url = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {'subject': subject},
      );
      canLaunchUrl(url).then((bool result) {
        if (result) {
          launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw ("Unable to open email");
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  //Open website in the browser
  void openWebsite(String url) {
    final uri = Uri.parse(url);
    canLaunchUrl(uri).then((bool result) {
      if (result) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ThemeToast.errorToast("Unable to open website");
      }
    });
  }

  //Share data on WhatsApp
  Future<void> shareOnWhatsApp(String message) async {
    final url = "whatsapp://send?text=$message";
    final uri = Uri.parse(url);
    await canLaunchUrl(uri).then((bool result) async {
      if (result) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    });
  }
}
