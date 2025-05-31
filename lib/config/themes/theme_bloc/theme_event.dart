part of 'theme_bloc.dart';
abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}
