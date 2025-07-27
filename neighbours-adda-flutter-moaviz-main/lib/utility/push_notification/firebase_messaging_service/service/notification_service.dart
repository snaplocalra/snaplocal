// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(
    this.flutterLocalNotificationsPlugin,
  );

  void foregroundNotificationTap(NotificationResponse details) {
    // print("*******************LOCAL FOREGROUND RECEIVED 1********************");
  }

  @pragma('vm:entry-point')
  static void backgroundNotificationTap(NotificationResponse details) {
    // print("*******************LOCAL BACKGROUND RECEIVED 2********************");
  }

  Future<void> foregroundConfig(
      {required AndroidNotificationChannel androidChannel}) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,

    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await createChannel(androidChannel);
  }

  Future<void> createChannel(
      AndroidNotificationChannel notificationChannel) async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
  }

  Future<void> initialize(BuildContext context,
      {required AndroidNotificationChannel androidChannel}) async {
    await foregroundConfig(androidChannel: androidChannel);
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
            "@mipmap/ic_launcher"); //'@mipmap/ic_launcher'

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: foregroundNotificationTap,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationTap,
    );
  }

  Future showNotification({
    int showNotificationId = 0,
    required AndroidNotificationDetails androidNotificationDetails,
    required DarwinNotificationDetails iosNotificationDetails,
    //
    String? title,
    String? body,
    String? payload,
  }) async {
    var platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      showNotificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
