import 'package:flutter/material.dart';

class AppTheme {
  static const Color dark = Color.fromARGB(255, 30, 29, 29);
  static const Color light = Color(0xFFf5f5f5);
  static const Color meduim = Color(0x50FFFFFF);
  static const Color accent = Color.fromARGB(255, 128, 108, 0);
  static const Color darkAccent = Color.fromARGB(255, 16, 53, 102);
  static const Color lightAccent = Color.fromARGB(255, 106, 166, 241);

  static const Color backgroundColor = Color.fromARGB(255, 60, 60, 60);

  static const Color disabledBackgroundColor = Colors.black12;
  static const Color disabledForegroundColor = Colors.white12;

  static const TextStyle inputStyle = TextStyle(color: light, fontSize: 20);
  static const TextStyle hintStyle = TextStyle(color: meduim);
  static const TextStyle counterStyle = TextStyle(color: meduim, fontSize: 14);
}
