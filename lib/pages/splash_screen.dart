import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app/pages/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    setSharedPreference();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'lib/images/icon.png',
          width: 100,
          height: 100,
          key: Key("image"),
        ),
      ),
    );
  }

  Future<void> setSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    var check = prefs.getBool("alarmPrefs");
    if (check == null) {
      prefs.setBool("alarmPrefs", false);
    }
  }
}
