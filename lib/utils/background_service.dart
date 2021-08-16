import 'dart:isolate';
import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/helper/connection_repositories.dart';
import 'package:restaurant_app/models/restaurant_model.dart';

import '../main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  Future<void> someTask() async {
    RestaurantModel data = await ConnectionRepositories().getListRestaurant();
    Random random = Random();
    var randomNumber = random.nextInt(data.restaurants.length);
    flutterLocalNotificationsPlugin.show(
        0,
        "${data.restaurants[randomNumber].name}",
        "Ayo kesini",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                icon: '@mipmap/ic_launcher',
                playSound: true)));
  }
}
