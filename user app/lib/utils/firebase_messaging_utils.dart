import 'dart:convert';
import 'dart:io';

import 'package:booking_system_flutter/utils/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../screens/booking/booking_detail_screen.dart';
import '../screens/jobRequest/my_post_detail_screen.dart';
import '../screens/service/service_detail_screen.dart';
import '../screens/wallet/user_wallet_balance_screen.dart';
import 'constant.dart';

Future<void> initFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, provisional: false, sound: true).then((value) async {
    if (value.authorizationStatus == AuthorizationStatus.authorized) {
      await registerNotificationListeners().catchError((e) {
        log('Notification Listener REGISTRATION ERROR : ${e}');
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true).catchError((e) {
        log('setForegroundNotificationPresentationOptions ERROR: ${e}');
      });
    }
  });
}

Future<bool> subscribeToFirebaseTopic() async {
  bool result = appStore.isSubscribedForPushNotification;
  if (appStore.isLoggedIn) {
    await initFirebaseMessaging();

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      log('Apn Token=========${apnsToken}');
    }

    await FirebaseMessaging.instance.subscribeToTopic('user_${appStore.userId}').then((value) {
      result = true;
      log("topic-----subscribed----> user_${appStore.userId}");
    });
    await FirebaseMessaging.instance.subscribeToTopic(USER_APP_TAG).then((value) {
      result = true;
      log("topic-----subscribed----> $USER_APP_TAG");
    });
  }

  await appStore.setPushNotificationSubscriptionStatus(result);
  return result;
}

Future<bool> unsubscribeFirebaseTopic(int userId) async {
  bool result = appStore.isSubscribedForPushNotification;
  await FirebaseMessaging.instance.unsubscribeFromTopic('user_$userId').then((_) {
    result = false;
    log("topic-----unsubscribed----> user_$userId");
  });
  await FirebaseMessaging.instance.unsubscribeFromTopic(USER_APP_TAG).then((_) {
    result = false;
    log("topic-----unsubscribed----> $USER_APP_TAG");
  });

  await appStore.setPushNotificationSubscriptionStatus(result);
  return result;
}

Future<void> registerNotificationListeners() async {
  FirebaseMessaging.instance.setAutoInitEnabled(true).then((value) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && message.notification!.title.validate().isNotEmpty && message.notification!.body.validate().isNotEmpty) {
        showNotification(currentTimeStamp(), message.notification!.title.validate(), parseHtmlString(message.notification!.body.validate()), message);
      }
    }, onError: (e) {
      log("setAutoInitEnabled error $e");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
    }, onError: (e) {
      log("onMessageOpenedApp Error $e");
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleNotificationClick(message);
      }
    }, onError: (e) {
      log("getInitialMessage error : $e");
    });
  }).onError((error, stackTrace) {
    log("onGetInitialMessage error: $error");
  });
}

void handleNotificationClick(RemoteMessage message) {
  if (message.data.containsKey('is_chat')) {
    LiveStream().emit(LIVESTREAM_FIREBASE, 3);
  } else if (message.data.containsKey('additional_data')) {
    Map<String, dynamic> additionalData = jsonDecode(message.data["additional_data"]) ?? {};
    int? id;
    if (additionalData.containsKey('id') && additionalData['id'] != null) {
      id = additionalData['id'];
      if (additionalData.containsKey('notification-type') && additionalData['notification-type'] == 'provider_send_bid') {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyPostDetailScreen(
              postRequestId: id.validate(),
              callback: () {},
            ),
          ),
        );
      } else if (additionalData.containsKey('check_booking_type') && additionalData['check_booking_type'] == 'booking') {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingId: additionalData['id'].toInt())));
      } else if (additionalData.containsKey('type') && additionalData['type'] == 'update_wallet') {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => UserWalletBalanceScreen()));
      }
    }
    if (additionalData.containsKey('service_id') && additionalData["service_id"] != null) {
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ServiceDetailScreen(serviceId: additionalData["service_id"].toInt())));
    }
  }
}

void showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
  log('Notification : ${remoteMessage.notification!.toMap()}');
  log('Message Data : ${remoteMessage.data}');
  log("User Message Image Url : ${remoteMessage.data["image_url"]} ");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //code for background notification channel
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'notification',
    'Notification',
    importance: Importance.high,
    enableLights: true,
    playSound: true,
    showBadge: true,
  );

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
  var iOS = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  var macOS = iOS;
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iOS, macOS: macOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      handleNotificationClick(remoteMessage);
    },
  );

  // region image logic
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  BigPictureStyleInformation? bigPictureStyleInformation = remoteMessage.data.containsKey("image_url")
      ? BigPictureStyleInformation(
          FilePathAndroidBitmap(await _downloadAndSaveFile(remoteMessage.data["image_url"], 'bigPicture')),
          largeIcon: FilePathAndroidBitmap(await _downloadAndSaveFile(remoteMessage.data["image_url"], 'largeIcon')),
        )
      : null;
  // endregion

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'notification',
    'Notification',
    importance: Importance.high,
    visibility: NotificationVisibility.public,
    autoCancel: true,
    playSound: true,
    priority: Priority.high,
    icon: '@drawable/ic_stat_ic_notification',
    largeIcon: remoteMessage.data.containsKey("image_url") ? FilePathAndroidBitmap(await _downloadAndSaveFile(remoteMessage.data["image_url"], 'largeIcon')) : null,
    styleInformation: remoteMessage.data.containsKey("image_url") ? bigPictureStyleInformation : null,
  );

  var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: darwinPlatformChannelSpecifics,
    macOS: darwinPlatformChannelSpecifics,
  );

  flutterLocalNotificationsPlugin.show(id, title, parseHtmlString(message), platformChannelSpecifics);
}
