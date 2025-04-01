import 'package:flutter/material.dart';
import 'package:task/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  //initially, theme is light mode
  ThemeData _themeData = lightMode;

  //getter method to ascess the theme from other part of code
  ThemeData get themeData => _themeData;

  // getter method  to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  //setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // we will use this toggle in a swicth later on ..
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
