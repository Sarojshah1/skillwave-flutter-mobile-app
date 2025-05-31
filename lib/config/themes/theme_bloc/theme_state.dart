part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class ThemeLight extends ThemeState {
  const ThemeLight() : super(ThemeMode.light);
}

class ThemeDark extends ThemeState {
  const ThemeDark() : super(ThemeMode.dark);
}
