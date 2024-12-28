import 'dart:ui';

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
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ).merge(
        TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Righteous',
            fontSize: 28, // Increased title size
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[
                  Color(0xFFCCCCCC),
                  Color(0xFFA9A9A9),
                ],
              ).createShader(
                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Righteous',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[
                  Color(0xFFCCCCCC),
                  Color(0xFFA9A9A9),
                ],
              ).createShader(
                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ).copyWith(
        background: Colors.black,
        error: Colors.red[900],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7DF9FF),
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
      ),
    ).copyWith(
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.cyan,
        cursorColor: Colors.pink,
        selectionColor: Colors.yellow.withOpacity(0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7DF9FF),
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 18,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(1, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[800],
        elevation: 5.0,
        margin: const EdgeInsets.all(16.0),
      ),
    );
  }
}

class ChromaticAberration extends StatelessWidget {
  final Widget child;
  final double offset;

  const ChromaticAberration({Key? key,
    required this.child,
    this.offset = 3.0, // Default offset value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        key: UniqueKey(),
        children: [
          child,

          Transform.translate(
            offset: Offset(offset, offset),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(const Color(0xFF7DF9FF).withOpacity(0.8), BlendMode.modulate ),
              child: child,
            ),
          ),

          Transform.translate(
            offset: Offset(-offset, -offset),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(const Color(0xFFFF0080).withOpacity(0.8), BlendMode.modulate),
              child: child,
            ),
          ),

          Transform.translate(
            offset: const Offset(0, 0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstOut ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class FilmGrain extends StatelessWidget {
  final Widget child;
  final double grainIntensity;

  const FilmGrain({
    Key? key,
    required this.child,
    this.grainIntensity = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: grainIntensity,
        sigmaY: grainIntensity,
      ),
      child: child,
    );
  }
}