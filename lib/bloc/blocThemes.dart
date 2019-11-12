import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum ApplicationTheme {
  lightTheme,
  darkTheme,
}

class BlocThemes extends BlocBase {
  @override
  void dispose() {
    _themeController.close();
    super.dispose();
  }

  final appThemeData = {
    ApplicationTheme.lightTheme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      primaryColor: Colors.red,
      accentColor: Colors.redAccent,
      iconTheme: IconThemeData(
        color: Colors.white
      )
    ),
    ApplicationTheme.darkTheme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.purple,
      primaryColor: Colors.deepPurple,
      accentColor: Colors.purpleAccent,
      iconTheme: IconThemeData(
        color: Colors.white
      )
    ),
  };

  ThemeData currentTheme() => appThemeData[_themeController.value];
  void selectTheme(ApplicationTheme theme) => inTheme.add(theme);
  ApplicationTheme selectedTheme() => _themeController.value;

  final BehaviorSubject<ApplicationTheme> _themeController = BehaviorSubject<ApplicationTheme>.seeded(ApplicationTheme.lightTheme);
  Stream<ApplicationTheme> get outTheme => _themeController.stream;
  Sink<ApplicationTheme> get inTheme => _themeController.sink;
}