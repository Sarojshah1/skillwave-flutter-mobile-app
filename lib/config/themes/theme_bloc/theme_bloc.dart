
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillwave/cores/shared_prefs/shared_pref_key.dart';

part 'theme_state.dart';
part 'theme_event.dart';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc(this.sharedPreferences) : super(const ThemeLight()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = state is ThemeLight ? const ThemeDark() : const ThemeLight();

    await sharedPreferences.setString(
        SharedPrefKeys.themeMode, newTheme.themeMode == ThemeMode.dark ? "dark" : "light");
    developer.log('ThemeBloc: Theme toggled to ${newTheme.themeMode}');
    emit(newTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final savedTheme = sharedPreferences.getString(SharedPrefKeys.themeMode);

    if (savedTheme == null) {
      // First install: default to light and save it
      await sharedPreferences.setString(SharedPrefKeys.themeMode, "light");
      developer.log("ThemeBloc: No theme set. Defaulting to Light.");
      emit(const ThemeLight());
    } else {
      final isLightMode = savedTheme == "light";
      developer.log("ThemeBloc: Loaded theme from SharedPreferences: ${isLightMode ? 'Light' : 'Dark'}");
      emit(isLightMode ? const ThemeLight() : const ThemeDark());
    }
  }

}
