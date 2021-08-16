part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class OnLoadedPrefs extends SettingState {
  final bool data;

  OnLoadedPrefs(this.data);
}

class OnPrefsTrue extends SettingState {
  final bool data;

  OnPrefsTrue(this.data);
}

class OnPrefsFalse extends SettingState {
  final bool data;

  OnPrefsFalse(this.data);
}
