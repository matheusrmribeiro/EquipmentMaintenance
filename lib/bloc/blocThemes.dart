import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../api/localSettings.dart';

enum ApplicationTheme {
  lightTheme,
  darkTheme,
}

class BlocThemes extends BlocBase {
  LocalSettings settings = LocalSettings();

  BlocThemes(){
    getInitialValues();
    _themeController.stream.listen((data){
      settings.preferences.setInt('theme', data.index);
    });
  }

  void getInitialValues() async{
    await settings.getInstance();
    if (settings.preferences.containsKey('theme'))
      inTheme.add(ApplicationTheme.values[settings.preferences.getInt('theme')]);
    else
      inTheme.add(ApplicationTheme.lightTheme);
  }

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

  final BehaviorSubject<ApplicationTheme> _themeController = BehaviorSubject<ApplicationTheme>();
  Stream<ApplicationTheme> get outTheme => _themeController.stream;
  Sink<ApplicationTheme> get inTheme => _themeController.sink;
}