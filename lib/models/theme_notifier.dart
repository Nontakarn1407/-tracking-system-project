import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      );

  ThemeData get darkTheme => ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      );

  get isDarkMode => null;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme; // สลับธีม
    notifyListeners(); // แจ้งว่ามีการเปลี่ยนแปลง
  }
}
