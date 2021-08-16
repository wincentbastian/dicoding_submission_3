part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class OnCheckSharedPreferences extends SettingEvent {
  const OnCheckSharedPreferences();
}

class OnChangeAlarmPrefs extends SettingEvent {
  final bool data;

  OnChangeAlarmPrefs(this.data);
}
