import 'package:flutter/material.dart';

class SynthwaveTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: const Color(0xFF7DF9FF),
      hintColor: const Color(0xFFFF0080),
      cardColor: Colors.red,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Righteous',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.black),
    );
  }
}