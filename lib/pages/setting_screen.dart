import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/setting_bloc/setting_bloc.dart';
import 'package:restaurant_app/helper/datetime_helper.dart';
import 'package:restaurant_app/utils/background_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

show() {
  BackgroundService().someTask();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingBloc settingBloc = SettingBloc();
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: Key("Appbar"),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            "Pengaturan",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder(
          bloc: settingBloc,
          builder: (context, state) {
            if (state is SettingInitial) {
              settingBloc.add(OnCheckSharedPreferences());
            } else if (state is OnLoadedPrefs) {
              return buildPage(context, state.data);
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Padding buildPage(BuildContext context, bool data) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Notifikasi",
            style: TextStyle(fontSize: 18, color: Colors.black),
            key: Key("notifikasi"),
          ),
          Switch(
              value: data,
              onChanged: (value) {
                settingBloc.add(OnChangeAlarmPrefs(value));
                if (value == true) {
                  AndroidAlarmManager.periodic(
                    Duration(hours: 24),
                    1,
                    show,
                    startAt: DateTimeHelper.format(),
                  );
                } else {
                  AndroidAlarmManager.cancel(1);
                }
              })
        ],
      ),
    );
  }
}
