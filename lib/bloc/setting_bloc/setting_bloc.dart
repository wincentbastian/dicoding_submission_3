import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial());

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if (event is OnCheckSharedPreferences) {
      final prefs = await SharedPreferences.getInstance();
      bool check = prefs.getBool("alarmPrefs")!;
      yield OnLoadedPrefs(check);
    } else if (event is OnChangeAlarmPrefs) {
      bool data = event.data;
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("alarmPrefs", data);
      yield SettingInitial();
    }
  }
}
