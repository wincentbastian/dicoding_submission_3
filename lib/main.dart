import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/pages/splash_screen.dart';
import 'package:restaurant_app/utils/background_service.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notification',
  'This channel is used for imporant notification.',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A big message just showed: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();
  AndroidAlarmManager.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BackgroundService _service = BackgroundService();
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
      port.listen((_) async => await _service.someTask());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("message published");
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      theme: ThemeData.light(),
      home: SplashScreen(),
    );
  }
}
