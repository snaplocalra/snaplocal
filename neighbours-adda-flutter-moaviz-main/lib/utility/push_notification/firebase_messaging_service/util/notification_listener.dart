// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snap_local/common/utils/local_notification/helper/notification_tap_navigation.dart';
import 'package:snap_local/utility/push_notification/firebase_messaging_service/model/push_notification_data_payload.dart';
import 'package:snap_local/utility/push_notification/firebase_messaging_service/service/notification_service.dart';

class PushNotificationHandler {
  Future<void> _notificationHandler(
      BuildContext context,
      RemoteMessage message, {
        bool showLocalNotification = false,
        bool allowScreenNavigation = true,
      }) async {
    try {
      print("|||||||||||||||||||||||||||Notification Handler|||||||||||||||||||||||||||");
      print(showLocalNotification);
      print(allowScreenNavigation);
      print(message.toMap());
      if (message.notification != null) {
        final channelId = message.notification?.android?.channelId;

        if (showLocalNotification) {
          await context.read<NotificationService>().showNotification(
            androidNotificationDetails: AndroidNotificationDetails(
              channelId ?? "buzzer_channel",
              "Default",
              channelDescription: "This channel is used for notifications Buzzer.",
              importance: Importance.defaultImportance, // 🔇 Lower importance
              priority: Priority.defaultPriority,
              playSound: false, // 🔇 No sound
            ),
            iosNotificationDetails: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: false, // 🔇 No sound
              sound: null,
            ),
            showNotificationId: 128,
            title: message.notification?.title,
            body: message.notification?.body ?? "You received a notification",
            payload: message.data.toString(),
          );
        }

        if (allowScreenNavigation) {
          final payLoad = PushNotificationDataPayload.fromMap(message.data);
          if (payLoad.notificationTapNavigationModel != null) {
            handleNotificationNavigation(
              context,
              payLoad.notificationTapNavigationModel!,
            );
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> listenToNotificaton(BuildContext context) async {
    try {
      const buzzerNotificationChannel = AndroidNotificationChannel(
        'buzzer_channel',
        'Buzzer',
        description: 'This channel is used for notifications Buzzer.',
        importance: Importance.defaultImportance, // 🔇 Lower importance
        playSound: false, // 🔇 Disable sound
      );

      await context
          .read<NotificationService>()
          .initialize(context, androidChannel: buzzerNotificationChannel);

      // Handling notification when the app opens from terminated state
      await FirebaseMessaging.instance
          .getInitialMessage()
          .then((initialRemoteMessage) async {
        if (initialRemoteMessage != null) {
          await _notificationHandler(context, initialRemoteMessage);
        }
      });

      // Handling notification when app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        if (context.mounted) {
          await _notificationHandler(context, message);
        }
      });

      // Handling notification when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (context.mounted) {
          await _notificationHandler(
            context,
            message,
            showLocalNotification: true,
            allowScreenNavigation: false,
          );
        }
      });
    } catch (e) {
      return;
    }
  }
}